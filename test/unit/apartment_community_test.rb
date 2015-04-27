require 'test_helper'

class ApartmentCommunityTest < ActiveSupport::TestCase
  context "An Apartment Community" do
    subject { ApartmentCommunity.make }

    should_have_neighborhood_listing_image(:neighborhood_listing_image, :required => false)
    should_be_mappable

    should have_many(:floor_plans)
    should have_many(:featured_floor_plans)
    should have_many(:under_construction_leads)
    should have_many(:floor_plan_groups).through(:floor_plans)

    should have_one(:mediaplex_tag)
    should have_one(:contact_configuration)

    should have_one(:neighborhood).dependent(:nullify)
    should have_many(:neighborhood_memberships).dependent(:destroy)
    should have_many(:area_memberships).dependent(:destroy)

    should_have_apartment_floor_plan_cache

    should allow_value(true).for:included_in_export
    should allow_value(false).for:included_in_export
    should_not allow_value(nil).for(:included_in_export)

    describe "updating caches" do
      before do
        @community    = ApartmentCommunity.make(:published => true)
        @neighborhood = Neighborhood.make(:apartment_communities => [subject, @community])
        @area         = Area.make(:apartment_communities => [subject, @community])
      end

      describe "after saving" do
        context "when its published flag is not changed" do
          it "does not update the count on its associated areas and neighborhoods" do
            @area.apartment_communities_count.should == 2
            @neighborhood.apartment_communities_count.should == 2

            subject.save!

            @area.reload.apartment_communities_count.should == 2
            @neighborhood.reload.apartment_communities_count.should == 2
          end
        end

        context "when its published flag is changed" do
          it "updates the count on its associated areas and neighborhoods" do
            @area.apartment_communities_count.should == 2
            @neighborhood.apartment_communities_count.should == 2

            subject.update_attributes(:published => false)

            @area.reload.apartment_communities_count.should == 1
            @neighborhood.reload.apartment_communities_count.should == 1

            subject.update_attributes(:published => true)

            @area.reload.apartment_communities_count.should == 2
            @neighborhood.reload.apartment_communities_count.should == 2
          end
        end
      end

      describe "after deletion" do
        it "updates the count on its associated areas and neighborhoods" do
          @area.apartment_communities_count.should == 2
          @neighborhood.apartment_communities_count.should == 2

          subject.destroy

          @area.reload.apartment_communities_count.should == 1
          @neighborhood.reload.apartment_communities_count.should == 1
        end
      end
    end

=begin
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
=end

    it "requires lead_2_lease email if show_lead_2_lease is true" do
      subject.show_lead_2_lease = true
      subject.lead_2_lease_email = nil
      subject.valid?.should == false
      subject.errors[:lead_2_lease_email].present?.should == true

      subject.lead_2_lease_email = 'test@example.com'
      subject.valid?
      subject.errors[:lead_2_lease_email].blank?.should == true
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
        @city = City.make

        @community = ApartmentCommunity.make(:latitude => 0, :longitude => 0, :city => @city)

        @nearby = (1..2).to_a.map do |i|
          ApartmentCommunity.make(:latitude => i, :longitude => i, :city => @city)
        end

        @unpublished = ApartmentCommunity.make(:unpublished,
                                               :latitude  => 2,
                                               :longitude => 2,
                                               :city      => @city)

        @in_other_city = ApartmentCommunity.make(:latitude  => 2,
                                                 :longitude => 2,
                                                 :city      => City.make)
      end

      it "returns the closest communities" do
        @community.nearby_communities.should == @nearby
      end
    end

    describe "#external_cms_attributes" do
      context "when the community is managed by the Carmel feed" do
        before { @community = ApartmentCommunity.make(:carmel) }

        it "returns the correct list of attributes to be overwritten in a merge" do
          @community.external_cms_attributes.should == [:floor_plans]
        end
      end

      context "when the community is not managed by the Carmel feed" do
        before { @community = ApartmentCommunity.make(:psi) }

        it "returns the correct list of attributes to be overwritten in a merge" do
          @community.external_cms_attributes.should == [
            :title,
            :street_address,
            :city,
            :county,
            :availability_url,
            :floor_plans
          ]
        end
      end
    end

    describe "#merge" do
      types = Bozzuto::ExternalFeed::Feed.feed_types

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
              attrs = subject.external_cms_attributes.reject { |attr| attr == :floor_plans }

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
        ApartmentCommunity.make(:vaultware, :floor_plans => [ApartmentFloorPlan.make(:vaultware)])
      }


      it "reset the external CMS identifiers to nil" do
        subject.disconnect_from_external_cms!

        subject.reload

        subject.external_cms_id.should == nil
        subject.external_cms_type.should == nil

        subject.floor_plans.each do |plan|
          plan.external_cms_id.should == nil
          plan.external_cms_type.should == nil
        end
      end
    end

    describe "caching floor plan data" do
      before do
        @studio    = ApartmentFloorPlanGroup.make(:studio)
        @penthouse = ApartmentFloorPlanGroup.make(:penthouse)
      end

      describe "#cheapest_price_in_group" do
        context "there are no floor plans" do
          before do
            subject.floor_plans.in_group(@studio).count.should == 0
          end

          it "returns 0" do
            subject.cheapest_price_in_group(@studio).should == 0.0
          end
        end

        context "there are floor plans" do
          before do
            @plan_1 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :min_rent         => 100.0
            )

            @plan_2 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :min_rent         => 200.0
            )

            @other = subject.floor_plans.make(
              :floor_plan_group => @penthouse,
              :min_rent         => 50.0
            )
          end

          it "returns the cheapest price" do
            subject.reload
            subject.cheapest_price_in_group(@studio).should == 100.0
          end
        end
      end

      describe "#plan_count_in_group" do
        context "there are no floor plans" do
          before do
            subject.floor_plans.in_group(@studio).count.should == 0
          end

          it "returns 0" do
            subject.plan_count_in_group(@studio).should == 0
          end
        end

        context "there are floor plans" do
          before do
            @plan_1 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :min_rent         => 100.0
            )

            @plan_2 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :min_rent         => 200.0
            )

            @other = subject.floor_plans.make(
              :floor_plan_group => @penthouse,
              :min_rent         => 50.0
            )
          end

          it "returns the count" do
            subject.reload
            subject.plan_count_in_group(@studio).should == 2
          end
        end
      end

      describe "#min_rent" do
        context "there are no floor plans" do
          before do
            subject.floor_plans.in_group(@studio).count.should == 0
          end

          it "returns 0" do
            subject.min_rent.should == 0
          end
        end

        context "there are floor plans" do
          before do
            @plan_1 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :min_rent         => 100.0
            )

            @plan_2 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :min_rent         => 200.0
            )

            @other = subject.floor_plans.make(
              :floor_plan_group => @penthouse,
              :min_rent         => 50.0
            )
          end

          it "returns the count" do
            subject.reload
            subject.min_rent.should == 50.0
          end
        end
      end

      describe "#max_rent" do
        context "there are no floor plans" do
          before do
            subject.floor_plans.in_group(@studio).count.should == 0
          end

          it "returns 0" do
            subject.max_rent.should == 0
          end
        end

        context "there are floor plans" do
          before do
            @plan_1 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :max_rent         => 100.0
            )

            @plan_2 = subject.floor_plans.make(
              :floor_plan_group => @studio,
              :max_rent         => 200.0
            )

            @other = subject.floor_plans.make(
              :floor_plan_group => @penthouse,
              :max_rent         => 50.0
            )
          end

          it "returns the count" do
            subject.reload
            subject.max_rent.should == 200.0
          end
        end
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
          :min_rent            => 0
        )

        @no_available_units = ApartmentFloorPlan.make(
          :apartment_community => subject,
          :available_units     => 0
        )

        @fully_available = ApartmentFloorPlan.make(
          :apartment_community => subject,
          :min_rent            => 100,
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

    describe "#id_for_export" do
      context "when the community has a core id" do
        subject { ApartmentCommunity.make(:core_id => 123) }

        it "returns the core id" do
          subject.id_for_export.should == 123
        end
      end

      context "when the community does not have a core id" do
        subject { ApartmentCommunity.make(:core_id => nil) }

        it "returns the record id" do
          subject.id_for_export.should == subject.id
        end
      end
    end

    describe "#main_export_community?" do
      context "when the community is both included in the export and published" do
        subject { ApartmentCommunity.make(:included_in_export => true, :published => true) }

        it "returns true" do
          subject.main_export_community?.should == true
        end
      end

      context "when the community is either excluded from the export or unpublished" do
        subject { ApartmentCommunity.make(:included_in_export => true, :published => false) }

        it "returns false" do
          subject.main_export_community?.should == false
        end
      end
    end

    describe "#project?" do
      it "returns false" do
        subject.project?.should == false
      end
    end

    describe "#apartment_community?" do
      it "returns true" do
        subject.apartment_community?.should == true
      end
    end

    describe "#home_community?" do
      it "returns false" do
        subject.home_community?.should == false
      end
    end
  end

  context "The ApartmentCommunity class" do
    before do
      create_floor_plan_groups

      @studio = ApartmentFloorPlanGroup.studio
      @one_br = ApartmentFloorPlanGroup.one_bedroom
      @two_br = ApartmentFloorPlanGroup.two_bedrooms

      @full_match    = ApartmentCommunity.make
      @partial_match = ApartmentCommunity.make
      @over_match    = ApartmentCommunity.make

      @full_match.floor_plans << ApartmentFloorPlan.make(:floor_plan_group => @two_br)
      @full_match.floor_plans << ApartmentFloorPlan.make(:floor_plan_group => @one_br)

      @partial_match.floor_plans << ApartmentFloorPlan.make(:floor_plan_group => @one_br)

      @over_match.floor_plans << ApartmentFloorPlan.make(:floor_plan_group => @studio)
      @over_match.floor_plans << ApartmentFloorPlan.make(:floor_plan_group => @two_br)
      @over_match.floor_plans << ApartmentFloorPlan.make(:floor_plan_group => @one_br)

      @garage    = PropertyFeature.make(:name => 'Garage',     :properties => [@over_match])
      @pool      = PropertyFeature.make(:name => 'Pool',       :properties => [@over_match, @full_match, @partial_match])
      @gym       = PropertyFeature.make(:name => 'Gym',        :properties => [@over_match, @full_match])
      @clubhouse = PropertyFeature.make(:name => 'Club House', :properties => [@over_match, @full_match, @partial_match])
    end

    it "responds to named scopes" do
      assert_nothing_raised do
        ApartmentCommunity.with_floor_plan_groups(1).all
        ApartmentCommunity.with_property_features([1, 2, 3]).all
        ApartmentCommunity.with_min_price(100)
        ApartmentCommunity.with_max_price(100)
        ApartmentCommunity.featured_order
        ApartmentCommunity.with_exclusive_floor_plans(1).all
        ApartmentCommunity.with_exclusive_features([1, 2, 3]).all
      end
    end

    describe ".duplicates" do
      before do
        @property = ApartmentCommunity.make(:title => 'Solaire')
        @other1   = ApartmentCommunity.make(:title => 'Solar')
        @other2   = ApartmentCommunity.make(:title => 'Batman')
      end

      it "returns both communities" do
        assert_same_elements [@property, @other1], ApartmentCommunity.duplicates
      end
    end

    describe "min and max prices" do
      before do
        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make

        @community_1.create_apartment_floor_plan_cache(:min_price => 50.0, :max_price => 100.0)
        @community_2.create_apartment_floor_plan_cache(:min_price => 150.0, :max_price => 200.0)
      end

      describe ".with_min_price" do
        it "returns the correct communities" do
          ApartmentCommunity.with_min_price(150.0).should == [@community_2]
        end
      end

      describe ".with_max_price" do
        it "returns the correct communities" do
          ApartmentCommunity.with_max_price(100.0).should == [@community_1]
        end
      end
    end

    describe ".with_floor_plan_groups" do
      it "returns communities matching any of the given floor plan criteria" do
        ApartmentCommunity.with_floor_plan_groups([@one_br.id, @two_br.id]).should == [@full_match, @partial_match, @over_match]
      end
    end

    describe ".with_property_features" do
      it "returns communities matching any of the given feature criteria" do
        ApartmentCommunity.with_property_features([@garage.id, @gym.id]).should == [@over_match, @full_match]
      end
    end

    describe ".with_exclusive_floor_plans" do
      it "returns communities exactly matching the given floor plan criteria" do
        ApartmentCommunity.with_exclusive_floor_plans([@one_br.id, @two_br.id]).should == [@full_match]
      end
    end

    describe ".with_exclusive_features" do
      it "returns communities exactly matching the given feature criteria" do
        ApartmentCommunity.with_exclusive_features([@clubhouse.id, @pool.id, @gym.id]).should == [@full_match]
      end
    end
  end
end
