require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  extend AlgoliaSearchable

  context "An Area" do
    subject { Area.make }

    it_should_behave_like "being searchable with algolia", Area, :name

    should_have_neighborhood_listing_image
    should_have_neighborhood_banner_image(:required => false)
    should_be_mappable
    should_have_seo_metadata

    should accept_nested_attributes_for(:related_areas)
    should accept_nested_attributes_for(:seo_metadata)
    should accept_nested_attributes_for(:area_memberships)

    should validate_presence_of(:name)
    should validate_presence_of(:latitude)
    should validate_presence_of(:longitude)
    should validate_presence_of(:metro)
    should validate_presence_of(:area_type)

    should validate_uniqueness_of(:name)

    should allow_value('neighborhoods').for(:area_type)
    should allow_value('communities').for(:area_type)
    should_not allow_value('blaugh').for(:area_type)
    should_not allow_value(nil).for(:area_type)

    should have_many(:neighborhoods).dependent(:destroy)
    should belong_to(:metro)
    should belong_to(:state)
    should have_many(:area_memberships).dependent(:destroy)
    should have_many(:apartment_communities).through(:area_memberships)

    should have_many(:related_areas).dependent(:destroy)
    should have_many(:nearby_areas).through(:related_areas)
    should have_many(:area_relations).dependent(:destroy)

    describe "nested structure" do
      describe "#to_s" do
        it "returns the name" do
          subject.to_s.should == subject.name
        end
      end

      describe "#parent" do
        it "returns the metro" do
          subject.parent.should == subject.metro
        end
      end

      describe "#lineage" do
        it "returns the metro and the area" do
          subject.lineage.should == [subject.metro, subject]
        end
      end

      describe "#lineage_hash" do
        it "returns the hash" do
          subject.lineage_hash.should == { :metro => subject.metro, :area => subject }
        end
      end

      context "area_type is 'neighborhoods'" do
        before do
          # area
          #   - neighborhood_1
          #     - community_1
          #       - floor_plan_1
          #     - community_2
          #       - floor_plan_2
          #     - community_3
          #   -neighborhood_2
          #     -community_1
          #       - floor_plan_1

          @community_1 = ApartmentCommunity.make
          @community_2 = ApartmentCommunity.make
          @community_3 = ApartmentCommunity.make

          @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
          @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

          @neighborhood_1 = Neighborhood.make
          @neighborhood_1.apartment_communities << [@community_1, @community_2, @community_3]

          @neighborhood_2 = Neighborhood.make
          @neighborhood_2.apartment_communities << [@community_1]

          subject.neighborhoods = [@neighborhood_1, @neighborhood_2]
          subject.save
        end

        describe "#children" do
          it "returns the neighborhoods" do
            subject.children.should == [@neighborhood_1, @neighborhood_2]
          end
        end

        describe "#communities" do
          it "returns all of the unique communities" do
            subject.communities.should == [@community_1, @community_2, @community_3]
          end
        end

        describe "#has_communities?" do
          context "when the area has communities" do
            it "returns true" do
              subject.has_communities?.should == true
            end
          end

          context "when the mtro does not have any communities" do
            it "returns false" do
              Area.make.has_communities?.should == false
            end
          end
        end

        describe "#available_floor_plans" do
          it "returns all of the unique floor plans" do
            subject.available_floor_plans.should == [@floor_plan_1, @floor_plan_2]
          end
        end

        describe "after saving" do
          it "updates the apartment communities count" do
            subject.apartment_communities_count.should == 3
          end

          it "updates the parent metro" do
            subject.metro.apartment_communities_count.should == 3
          end
        end

        describe "after destroying" do
          it "updates the count on the parent metro" do
            metro = subject.metro
            metro.apartment_communities_count.should == 3

            subject.destroy

            metro.reload
            metro.apartment_communities_count.should == 0
          end
        end
      end

      context "area_type is 'communities'" do
        subject { Area.make(:communities) }

        before do
          # area
          #   - community_1
          #     - floor_plan_1
          #   - community_2
          #     - floor_plan_2

          @community_1 = ApartmentCommunity.make
          @community_2 = ApartmentCommunity.make

          @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
          @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

          subject.apartment_communities = [@community_1, @community_2]
          subject.save
        end

        describe "#children" do
          it "returns nil" do
            subject.children.should == nil
          end
        end

        describe "#communities" do
          it "returns all of the unique communities" do
            subject.communities.should == [@community_1, @community_2]
          end
        end

        describe "#available_floor_plans" do
          it "returns all of the unique floor plans" do
            subject.available_floor_plans.should == [@floor_plan_1, @floor_plan_2]
          end
        end

        describe "after saving" do
          it "updates the apartment communities count" do
            subject.apartment_communities_count.should == 2
          end

          it "updates the parent metro" do
            subject.metro.apartment_communities_count.should == 2
          end
        end

        describe "after destroying" do
          it "updates the count on the parent metro" do
            metro = subject.metro
            metro.apartment_communities_count.should == 2

            subject.destroy

            metro.reload
            metro.apartment_communities_count.should == 0
          end
        end
      end
    end

    describe "#shows_neighborhoods?" do
      context "area_type is 'neighborhoods'" do
        it "returns true" do
          subject.area_type = 'neighborhoods'
          subject.shows_neighborhoods?.should == true
        end
      end

      context "area_type is 'communities'" do
        it "returns false" do
          subject.area_type = 'communities'
          subject.shows_neighborhoods?.should == false
        end
      end
    end

    describe "#shows_communities?" do
      context "area_type is 'neighborhoods'" do
        it "returns false" do
          subject.area_type = 'neighborhoods'
          subject.shows_communities?.should == false
        end
      end

      context "area_type is 'communities'" do
        it "returns true" do
          subject.area_type = 'communities'
          subject.shows_communities?.should == true
        end
      end
    end

    describe "#nearby_communities" do
      before do
        # area_1
        #   - community_1
        #   - community_2
        #
        # area_2
        #   - neighborhood_1
        #     - community_3
        #     - community_4
        #   - neighborhood_2
        #     - community_4

        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make
        @community_3 = ApartmentCommunity.make
        @community_4 = ApartmentCommunity.make

        @neighborhood_1 = Neighborhood.make
        @neighborhood_1.apartment_communities << [@community_3, @community_4]

        @neighborhood_2 = Neighborhood.make
        @neighborhood_2.apartment_communities << [@community_4]

        @area_1 = Area.make(:communities)
        @area_2 = Area.make(:neighborhoods)

        @area_1.apartment_communities = [@community_1, @community_2]
        @area_1.save

        @area_2.neighborhoods = [@neighborhood_1, @neighborhood_2]
        @area_2.save

        subject.nearby_areas = [@area_1, @area_2]
        subject.save
      end

      it "returns the nearby communities" do
        subject.nearby_communities.should == [@community_1, @community_2, @community_3, @community_4]
      end
    end

    describe "#tier_for" do
      subject { Area.make(:communities) }
      before  { @community = ApartmentCommunity.make }

      context "when the given community has a membership with the area" do
        before do
          @membership = AreaMembership.make(
            :area                => subject,
            :apartment_community => @community,
            :tier                => 2
          )
        end

        it "returns the tier" do
          subject.tier_for(@community).should == 2
        end
      end

      context "when the given community does not have a membership with the area" do
        it "does not raise a NoMethodError" do
          expect { subject.tier_for(@community) }.to_not raise_error
        end
      end
    end

    describe "#tier_1_community_slides" do
      before do
        @subject = Area.make(:communities)

        @subject.apartment_communities = (1..4).map do |i|
          instance_variable_set(
            "@community_#{i}",
            ApartmentCommunity.make(:hero_image_file_name => Sham.file_name)
          )
        end

        @community_1.area_memberships.first.update_attribute(:tier, 1)
        @community_2.area_memberships.first.update_attribute(:tier, 1)
        @community_3.area_memberships.first.update_attribute(:tier, 2)
        @community_4.area_memberships.first.update_attribute(:tier, 3)
      end

      it "returns a slide for each tier 1 community in the neighborhood" do
        @subject.reload.tier_1_community_slides.should =~ [
          Bozzuto::Neighborhoods::Slideshow::Slide.new(@community_1),
          Bozzuto::Neighborhoods::Slideshow::Slide.new(@community_2)
        ]
      end
    end
  end
end
