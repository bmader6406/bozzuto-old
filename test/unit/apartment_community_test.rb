require 'test_helper'

class ApartmentCommunityTest < ActiveSupport::TestCase
  context "An Apartment Community" do
    subject { ApartmentCommunity.make }

    should_have_many(:floor_plans, :featured_floor_plans, :under_construction_leads)
    should_have_many(:floor_plan_groups, :through => :floor_plans)

    should_have_one(:mediaplex_tag)
    should_have_one(:contact_configuration)
    should_have_one(:neighborhood, :dependent => :nullify)

    it "is archivable" do
      assert ApartmentCommunity.acts_as_archive?
      assert_nothing_raised do
        ApartmentCommunity::Archive
      end
      assert defined?(ApartmentCommunity::Archive)
      assert ApartmentCommunity::Archive.ancestors.include?(ActiveRecord::Base)
      assert ApartmentCommunity::Archive.ancestors.include?(Property::Archive)
      assert ApartmentCommunity::Archive.ancestors.include?(Community::Archive)
    end

    it "requires lead_2_lease email if show_lead_2_lease is true" do
      subject.show_lead_2_lease = true
      subject.lead_2_lease_email = nil
      subject.valid?.should == false
      subject.errors.on(:lead_2_lease_email).present?.should == true

      subject.lead_2_lease_email = 'test@example.com'
      subject.valid?
      subject.errors.on(:lead_2_lease_email).blank?.should == true
    end

    it "sets featured_position when changed to being featured" do
      subject.featured = true
      subject.save!

      subject.featured_position.present?.should == true
    end

    context "that is featured" do
      before do
        subject.featured = true
        subject.save!
      end

      it "removes the featured position when they lose their featured status" do
        subject.featured = false
        subject.save!

        subject.featured_position.nil?.should == true
      end
    end

    describe "#nearby_communities" do
      before do
        @city        = City.make
        @communities = []

        3.times do |i|
          @communities << ApartmentCommunity.make(
            :latitude  => i,
            :longitude => i,
            :city      => @city
          )
        end

        @unpublished = ApartmentCommunity.make(
          :latitude  => 3,
          :longitude => 3,
          :published => false,
          :city      => @city
        )
      end

      it "returns the closest communities" do
        nearby = @communities[0].nearby_communities

        nearby.length.should == 2
        nearby[0].should == @communities[1]
        nearby[1].should == @communities[2]
      end

      it "nots include unpublished communities" do
        @communities.should_not include(@unpublished)
      end
    end

    describe "changing use_market_prices" do
      before do
        @plan = ApartmentFloorPlan.make(
          :min_effective_rent  => 100,
          :min_market_rent     => 200,
          :max_effective_rent  => 300,
          :max_market_rent     => 400,
          :apartment_community => subject
        )
      end

      it "update the cached floor plan prices" do
        @plan.min_rent.should == @plan.min_effective_rent
        @plan.max_rent.should == @plan.max_effective_rent

        subject.update_attributes(:use_market_prices => true)
        @plan.reload

        @plan.min_rent.should == @plan.min_market_rent
        @plan.max_rent.should == @plan.max_market_rent
      end
    end

    describe "#merge" do
      types = Bozzuto::ExternalFeedLoader.feed_types

      types.each do |type|
        context "receiver is a #{type} community" do
          subject { ApartmentCommunity.make(type.to_sym) }

          it "raises an exception" do
            begin
              subject.merge(nil)
              assert false, 'Expected an exception'
            rescue RuntimeError => e
              e.message.should == 'Receiver must not be an externally-managed community'
            end
          end
        end
      end

      context "receiver is not an externally-managed community" do
        context "and other community is not externally-managed" do
          before do
            @other = ApartmentCommunity.make
          end

          it "raise an exception" do
            begin
              subject.merge(@other)
              assert false, 'Expected an exception'
            rescue RuntimeError => e
              e.message.should == 'Argument must be an externally-managed community'
            end
          end
        end

        types.each do |type|
          context "and other community is #{type}" do
            subject do
              @community = ApartmentCommunity.make(
                :title            => 'Receiver',
                :street_address   => '123 Test Dr',
                :city             => City.make,
                :county           => County.make,
                :availability_url => 'http://google.com'
              )
            end

            before do
              @community_floor_plans = [
                ApartmentFloorPlan.make(:apartment_community => subject),
                ApartmentFloorPlan.make(:apartment_community => subject)
              ]

              # configure other community
              @other = ApartmentCommunity.make(type.to_sym,
                :title            => "#{type} managed",
                :street_address   => '456 Test Dr',
                :city             => City.make,
                :county           => County.make,
                :availability_url => 'http://yahoo.com'
              )

              @other_floor_plans = [
                ApartmentFloorPlan.make(:apartment_community => @other),
                ApartmentFloorPlan.make(:apartment_community => @other),
                ApartmentFloorPlan.make(:apartment_community => @other)
              ]

              subject.merge(@other)
              subject.reload
            end

            it "update the receiver's attributes" do
              attrs = ApartmentCommunity.external_cms_attributes.reject { |attr| attr == :floor_plans }

              attrs.each do |attr|
                subject.send(attr).should == @other.send(attr)
              end
            end

            it "set the external_cms_id of the receiver" do
              subject.external_cms_id.should == @other.external_cms_id
            end

            it "set the external_cms_type of the receiver" do
              subject.external_cms_type.should == @other.external_cms_type
            end

            it "delete the receiver's floor plans" do
              @community_floor_plans.each { |plan|
                ApartmentFloorPlan.find_by_id(plan.id).should == nil
              }
            end

            it "not delete other's floor plans" do
              @other_floor_plans.each { |plan|
                ApartmentFloorPlan.find(plan.id).present?.should == true
              }
            end

            it "assign the floor plans to the receiver" do
              subject.floor_plans(true).should == @other_floor_plans
            end

            it "destroy the other record" do
              @other.destroyed?.should == true
            end
          end
        end
      end
    end

    describe "#disconnect_from_external_cms!" do
      subject {
        ApartmentCommunity.make(:vaultware, :floor_plans => [ApartmentFloorPlan.make_unsaved(:vaultware)])
      }

      it "reset the external CMS identifiers to nil" do
        subject.disconnect_from_external_cms!

        subject.reload

        subject.external_cms_id.should == nil
        subject.external_cms_type.should == nil

        subject.floor_plans.each do |plan|
          subject.external_cms_id.should == nil
          subject.external_cms_type.should == nil
          subject.external_cms_file_id.should == nil
        end
      end
    end

    describe "#min_rent" do
      context "managed internally" do
        before do
          @plan1 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :min_effective_rent  => 4000
          )

          @plan2 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :min_effective_rent  => 0
          )
        end

        it "returns the lowest price, including 0" do
          subject.min_rent.to_i.should == 0
        end
      end

      context "managed externally" do
        subject { ApartmentCommunity.make(:vaultware) }

        before do
          @plan1 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :min_effective_rent  => 4000
          )

          @plan2 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :min_effective_rent  => 10
          )

          @plan3 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :min_effective_rent  => 100
          )
        end

        it "returns the lowest price > 0" do
          subject.min_rent.to_i.should == 10
        end
      end
    end

    describe "#max_rent" do
      context "managed internally" do
        before do
          @plan1 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :max_effective_rent  => 4000
          )

          @plan2 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :max_effective_rent  => 0
          )
        end

        it "returns the max price, including 0" do
          subject.max_rent.to_i.should == 4000
        end
      end

      context "managed externally" do
        subject { ApartmentCommunity.make(:vaultware) }

        before do
          @plan1 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :max_effective_rent  => 4000
          )

          @plan2 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :max_effective_rent  => 3000
          )

          @plan3 = ApartmentFloorPlan.make(
            :apartment_community => subject,
            :max_effective_rent  => 0
          )
        end

        it "returns the max price, which must be > 0" do
          subject.max_rent.to_i.should == 4000
        end
      end
    end

    describe "#cheapest_price_in_group" do
      before do
        @group = ApartmentFloorPlanGroup.make(:studio)
        subject.cheapest_studio_price = '100'
      end

      it "return the cheapest price" do
        subject.cheapest_price_in_group(@group).should == '100'
      end
    end

    describe "#plan_count_in_group" do
      before do
        @group = ApartmentFloorPlanGroup.make(:studio)
        subject.plan_count_studio = 25
      end

      it "return the plan count" do
        subject.plan_count_in_group(@group).should == 25
      end
    end

    describe "#managed_externally?" do
      context "CMS type/id fields are blank" do
        it "be false" do
          assert !subject.managed_externally?
        end
      end
    end

    describe "#apartment_community?" do
      before do
        subject = ApartmentCommunity.new
      end

      it "return true" do
        subject.apartment_community?.should == true
      end
    end

    describe "#home_community?" do
      before do
        subject = ApartmentCommunity.new
      end

      it "return false" do
        subject.home_community?.should == false
      end
    end

    describe "#available_floor_plans" do
      before do
        @zero_min_rent = ApartmentFloorPlan.make(
          :apartment_community => subject,
          :min_effective_rent  => 0
        )

        @no_available_units = ApartmentFloorPlan.make(
          :apartment_community => subject,
          :available_units     => 0
        )

        @fully_available = ApartmentFloorPlan.make(
          :apartment_community => subject,
          :min_effective_rent  => 100,
          :available_units     => 10
        )
      end

      context "managed internally" do
        it "returns all floor plans" do
          plans = subject.available_floor_plans

          plans.length.should == 2
          plans.should include(@zero_min_rent)
          plans.should include(@fully_available)
          plans.should_not include(@no_available_units)
        end
      end

      context "community is managed externally" do
        before do
          subject.external_cms_id   = 123
          subject.external_cms_type = 'vaultware'
        end

        it "returns only plans with min_rent > 0" do
          subject.available_floor_plans.should == [@fully_available]
        end
      end
    end
  end

  context "The ApartmentCommunity class" do
    it "responds to named scopes" do
      assert_nothing_raised do
        ApartmentCommunity.with_floor_plan_groups(1).all
        ApartmentCommunity.with_min_price(0).all
        ApartmentCommunity.with_max_price(1000).all
        ApartmentCommunity.with_property_features([1, 2, 3]).all
        ApartmentCommunity.featured_order
      end
    end

    context "duplicates scope" do
      before do
        @property = ApartmentCommunity.make(:title => 'Solaire')
        @other1   = ApartmentCommunity.make(:title => 'Solar')
        @other2   = ApartmentCommunity.make(:title => 'Batman')
      end

      it "returns both communities" do
        assert_same_elements [@property, @other1], ApartmentCommunity.duplicates
      end
    end
  end
end
