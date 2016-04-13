require 'test_helper'

class ApartmentCommunityTest < ActiveSupport::TestCase
  context "An Apartment Community" do
    subject { ApartmentCommunity.make }

    should_have_neighborhood_listing_image(:neighborhood_listing_image, required: false)

    should_be_mappable

    should belong_to(:city)
    should belong_to(:county)
    should belong_to(:promo)
    should belong_to(:twitter_account)

    should have_many(:property_feature_attributions)
    should have_many(:property_features).through(:property_feature_attributions)
    should have_many(:floor_plans)
    should have_many(:featured_floor_plans)
    should have_many(:under_construction_leads)
    should have_many(:floor_plan_groups).through(:floor_plans)
    should have_many(:photos)
    should have_many(:videos)
    should have_many(:neighborhood_memberships).dependent(:destroy)
    should have_many(:area_memberships).dependent(:destroy)
    should have_many(:landing_page_popular_orderings).dependent(:destroy)
    should have_many(:office_hours).dependent(:destroy)
    should have_many(:property_amenities).dependent(:destroy)

    should have_one(:slideshow)
    should have_one(:dnr_configuration)
    should have_one(:features_page)
    should have_one(:neighborhood_page)
    should have_one(:tours_page)
    should have_one(:contact_page)
    should have_one(:mediaplex_tag)
    should have_one(:contact_configuration)
    should have_one(:neighborhood).dependent(:nullify)

    should have_attached_file(:listing_image)
    should have_attached_file(:hero_image)
    should have_attached_file(:brochure)

    should accept_nested_attributes_for(:office_hours)
    should accept_nested_attributes_for(:property_amenities)
    should accept_nested_attributes_for(:dnr_configuration)
    should accept_nested_attributes_for(:mediaplex_tag)
    should accept_nested_attributes_for(:contact_configuration)

    should_have_apartment_floor_plan_cache

    should validate_presence_of(:title)
    should validate_presence_of(:city)
    should validate_length_of(:short_title).is_at_least(0).is_at_most(22)
    should validate_length_of(:short_description).is_at_least(0).is_at_most(40)

    should allow_value(true).for(:included_in_export)
    should allow_value(false).for(:included_in_export)
    should_not allow_value(nil).for(:included_in_export)

    describe "creating a new record" do
      subject { ApartmentCommunity.make_unsaved }

      context "and featured is false" do
        before do
          subject.featured = false
        end

        it "has a default featured_position of nil" do
          subject.save
          subject.featured_position.should == nil
        end
      end

      context "and featured is true" do
        before do
          subject.featured = true
        end

        it "has a default featured_position of 1" do
          subject.save
          subject.featured_position.should == 1
        end
      end
    end

    context "before save" do
      subject do
        ApartmentCommunity.make(
          phone_number:        '(815) 381-3919',
          mobile_phone_number: '815.381.3919'
        )
      end

      it "formats both the phone number and mobile phone number" do
        subject.save

        subject.read_attribute(:phone_number).should        == '8153813919'
        subject.read_attribute(:mobile_phone_number).should == '8153813919'
      end
    end

    context "scopes" do
      before do
        create_floor_plan_groups

        @studio = ApartmentFloorPlanGroup.studio
        @one_br = ApartmentFloorPlanGroup.one_bedroom
        @two_br = ApartmentFloorPlanGroup.two_bedrooms
        @thr_br = ApartmentFloorPlanGroup.three_bedrooms
        @pent   = ApartmentFloorPlanGroup.penthouse

        @full_match    = ApartmentCommunity.make
        @partial_match = ApartmentCommunity.make
        @over_match    = ApartmentCommunity.make

        @full_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @thr_br)
        @full_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @one_br)

        @partial_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @one_br)

        @over_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @studio)
        @over_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @two_br)
        @over_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @thr_br)
        @over_match.floor_plans << ApartmentFloorPlan.make(floor_plan_group: @one_br)

        @garage    = PropertyFeature.make(name: 'Garage',     apartment_communities: [@over_match])
        @pool      = PropertyFeature.make(name: 'Pool',       apartment_communities: [@over_match, @full_match, @partial_match])
        @gym       = PropertyFeature.make(name: 'Gym',        apartment_communities: [@over_match, @full_match])
        @clubhouse = PropertyFeature.make(name: 'Club House', apartment_communities: [@over_match, @full_match, @partial_match])
      end

      describe ".duplicates" do
        before do
          @property = ApartmentCommunity.make(title: 'Solaire')
          @other1   = ApartmentCommunity.make(title: 'Solar')
          @other2   = ApartmentCommunity.make(title: 'Batman')
        end

        it "returns both communities" do
          ApartmentCommunity.duplicates.should match_array [@property, @other1]
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

      describe ".with_any_floor_plan_groups" do
        it "returns communities matching any of the given floor plan criteria" do
          ApartmentCommunity.with_any_floor_plan_groups([@one_br.id, @two_br.id]).order(:id).should == [@full_match, @partial_match, @over_match]
        end
      end

      describe ".with_any_property_features" do
        it "returns communities matching any of the given feature criteria" do
          ApartmentCommunity.with_any_property_features([@garage.id, @gym.id]).order(:id).should == [@full_match, @over_match]
        end
      end

      describe ".with_exact_floor_plan_groups" do
        it "returns communities exactly matching the given floor plan criteria" do
          ApartmentCommunity.with_exact_floor_plan_groups([@one_br.id, @thr_br.id]).should == [@full_match]
        end
      end

      describe ".with_exact_property_features" do
        it "returns communities exactly matching the given feature criteria" do
          ApartmentCommunity.with_exact_property_features([@clubhouse.id, @pool.id, @gym.id]).should == [@full_match]
        end
      end

      describe ".having_all_floor_plan_groups" do
        it "returns communities having all the given floor plan criteria" do
          ApartmentCommunity.having_all_floor_plan_groups([@one_br.id, @thr_br.id]).should match_array [@full_match, @over_match]
        end
      end

      describe ".having_all_property_features" do
        it "returns communities matching all the given feature criteria" do
          ApartmentCommunity.having_all_property_features([@clubhouse.id, @pool.id, @gym.id]).should match_array [@full_match, @over_match]
        end
      end

      describe ".with_twitter_account" do
        before do
          @account = TwitterAccount.new(username: 'TheBozzutoGroup')
          @account.save(validate: false)

          @community = ApartmentCommunity.make(twitter_account: @account)
          @other     = ApartmentCommunity.make
        end

        it "returns only the communities with a twitter account" do
          ApartmentCommunity.with_twitter_account.should == [@community]
        end
      end
    end

    context "updating caches" do
      before do
        @community    = ApartmentCommunity.make(:published => true)
        @neighborhood = Neighborhood.make()
        @neighborhood.apartment_communities << [subject, @community]

        @area = Area.make
        @area.apartment_communities << [subject, @community]
      end

      context "after saving" do
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

      context "after deletion" do
        it "updates the count on its associated areas and neighborhoods" do
          @area.apartment_communities_count.should == 2
          @neighborhood.apartment_communities_count.should == 2

          subject.destroy

          @area.reload.apartment_communities_count.should == 1
          @neighborhood.reload.apartment_communities_count.should == 1
        end
      end
    end

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

    describe "#to_param" do
      context "when a community's slug already includes its ID" do
        subject { ApartmentCommunity.make(id: 99001, title: 'Test', slug: '99001-test') }

        it "returns the ID combined with the title" do
          subject.to_param.should == '99001-test'
        end
      end

      context "when a community's slug does not include its ID" do
        subject { ApartmentCommunity.make(id: 99001, title: 'Test', slug: 'test') }

        it "returns the ID combined with the title" do
          subject.to_param.should == '99001-test'
        end
      end

      context "after updating an apartment community" do
        subject { ApartmentCommunity.make(id: 99001, title: 'Test', slug: '99001-test') }

        before do
          subject.update_attributes(title: 'boom')
        end

        it "returns the ID combined with the updated title" do
          subject.slug.should == '99001-boom'
        end
      end
    end

    describe "#mappable?" do
      setup do
        subject.latitude  = 10
        subject.longitude = 10
      end

      should "return true if latitude and longitude are both present" do
        subject.mappable?.should == true
      end

      should "return false if latitude or longitude isn't present" do
        subject.latitude          = nil
        subject.mappable?.should == false

        subject.latitude          = 10
        subject.longitude         = nil
        subject.mappable?.should == false
      end
    end

    describe "#address" do
      setup do
        @address = '202 Rigsbee Ave'
      end

      subject { ApartmentCommunity.make(street_address: @address) }

      context "with no separator parameter" do
        should "return the formatted address, separated by ', '" do
          subject.address.should == "#{@address}, #{subject.city}"
        end
      end

      context "with separator parameter" do
        should "return the formatted address, separated by the provided separator" do
          subject.address('<br />').should == "#{@address}<br />#{subject.city}"
        end
      end
    end

    describe "#state" do
      setup do
        @state = State.make
      end

      subject { ApartmentCommunity.make(city: City.make(state: @state)) }

      should "return the city's state" do
        subject.state.should == @state
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

    describe "#merge" do
      types = Bozzuto::ExternalFeed::SOURCES

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
                :external_cms_id  => 't3st',
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

              @core_id = subject.core_id

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
              subject.external_cms_id.should == 't3st'
            end

            it "set the external_cms_type of the receiver" do
              subject.external_cms_type.should == type
            end

            it "does not change the core ID on the receiver" do
              subject.core_id.should == @core_id
            end

            it "transfers slugs to the receiver" do
              subject.slugs.pluck(:slug).should include @other.slug
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

    describe "#pages" do
      subject { ApartmentCommunity.make }

      before do
        @features     = PropertyFeaturesPage.make(property: subject)
        @neighborhood = PropertyNeighborhoodPage.make(property: subject)
        @contact      = PropertyContactPage.make(property: subject)
      end

      it "returns all the pages" do
        subject.pages.should match_array [@features, @neighborhood, @contact]
      end
    end

    describe "querying the mobile phone number field" do
      before do
        @phone_number = '1 (111) 111-1111'
      end

      subject { ApartmentCommunity.make(:phone_number => @phone_number) }

      context "and no mobile phone number is set" do
        before do
          subject.mobile_phone_number = nil
        end

        it "returns the phone number" do
          subject.mobile_phone_number.should == '111.111.1111'
        end
      end

      context "and mobile phone number is set" do
        before do
          @mobile_phone_number = '1 (234) 567-8900'

          subject.mobile_phone_number = @mobile_phone_number
        end

        it "returns the mobile phone number" do
          subject.mobile_phone_number.should == '234.567.8900'
        end
      end
    end

    describe "#twitter_handle" do
      context "when there is a twitter account" do
        before do
          @account = TwitterAccount.new(:username => 'TheBozzutoGroup')
          @account.save(:validate => false)

          subject.twitter_account = @account
        end

        it "returns the twitter username" do
          subject.twitter_handle.should == 'TheBozzutoGroup'
        end
      end

      context "when there is not a twitter account" do
        it "returns nil" do
          subject.twitter_handle.should == nil
        end
      end
    end

    describe "#has_overview_bullets?" do
      it "returns false if all bullets are empty" do
        (1..3).each do |i|
          subject.send("overview_bullet_#{i}").should == nil
        end

        subject.has_overview_bullets?.should == false
      end

      it "returns true if any bullets are present" do
        subject.overview_bullet_2 = 'Blah blah blah'

        subject.has_overview_bullets?.should == true
      end
    end

    describe "#features_page?" do
      subject { ApartmentCommunity.make }

      it "return false if there is no features page attached" do
        subject.features_page?.should == false
      end

      it "return true if there is a features page attached" do
        @page = PropertyFeaturesPage.make(:property => subject)

        subject.features_page?.should == true
      end
    end

    describe "#neighborhood_page?" do
      subject { ApartmentCommunity.make }

      it "returns false if there is no neighborhood page attached" do
        subject.neighborhood_page?.should == false
      end

      it "returns true if there is a neighborhood page attached" do
        @page = PropertyNeighborhoodPage.make(:property => subject)

        subject.neighborhood_page?.should == true
      end
    end

    describe "#contact_page?" do
      subject { ApartmentCommunity.make }

      it "returns false if there is no contact page attached" do
        subject.contact_page?.should == false
      end

      it "returns true if there is a contact page attached" do
        @page = PropertyContactPage.make(:property => subject)

        subject.contact_page?.should == true
      end
    end

    describe "#has_media?" do
      subject { ApartmentCommunity.make }

      context "without any media" do
        it "returns false" do
          subject.has_media?.should == false
        end
      end

      context "with a photo" do
        before do
          Photo.make(:property => subject)
        end

        it "returns true" do
          subject.has_media?.should == true
        end
      end

      context "with a video" do
        before do
          Video.make(property: subject)
        end

        it "returns true" do
          subject.has_media?.should == true
        end
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

    context "#apartment?" do
      it "returns true" do
        subject.apartment?.should == true
      end
    end

    context "#home?" do
      it "returns false" do
        subject.home?.should == false
      end
    end

    context "#project?" do
      it "returns false" do
        subject.project?.should == false
      end
    end

    describe "#has_active_promo?" do
      before do
        @active_promo  = Promo.make :active
        @expired_promo = Promo.make :expired
      end

      context "when promo is not present" do
        before do
          subject.promo = nil
        end

        it "returns false" do
          subject.has_active_promo?.should == false
        end
      end

      context "when promo is present and not active" do
        before do
          subject.promo = @expired_promo
        end

        it "returns false" do
          subject.has_active_promo?.should == false
        end
      end

      context "when promo is present and active" do
        before do
          subject.promo = @active_promo
        end

        it "returns true" do
          subject.has_active_promo?.should == true
        end
      end
    end

    context "with SMSAble mixed in" do
      before do
        subject.title          = "Pearson Square"
        subject.street_address = "410 S. Maple Ave"
        subject.city           = City.new(:name => "Falls Church", :state => State.new(:name => "Virginia"))
        subject.phone_number   = '888-478-8640'
        subject.website_url    = "http://bozzuto.com/pearson"
      end

      it "has a phone message for sms" do
        subject.phone_message.should == "Pearson Square 410 S. Maple Ave, Falls Church, Virginia 888.478.8640 Call for specials! http://bozzuto.com/pearson"
      end

      it "has attributes including phone number" do
        subject.stubs(:phone_message).returns("this is a message")

        params = subject.phone_params('1234567890')

        ["to=1234567890", "username=#{APP_CONFIG[:sms]['username']}",
          "pword=#{APP_CONFIG[:sms]['password']}", "sender=#{APP_CONFIG[:sms]['sender']}",
          "message=this+is+a+message"].each do |qs|

          params.include?(qs).should == true
        end
      end

      it "sends a message to i2sms via get" do
        subject.stubs(:phone_params).returns("params")
        HTTParty.expects(:get).with("#{Bozzuto::SMSAble::URL}?params")

        subject.send_info_message_to('1234567890')
      end

      it "prefixes a one to phone number if none is present" do
        HTTParty.stubs(:get)
        subject.expects(:phone_params).with('15551234567')

        subject.send_info_message_to('5551234567')
      end

      it "doesn't prefix a one to phone numbers starting with a one" do
        HTTParty.stubs(:get)
        subject.expects(:phone_params).with('15550987654')

        subject.send_info_message_to('15550987654')
      end
    end
  end
end
