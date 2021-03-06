require 'test_helper'

class NeighborhoodTest < ActiveSupport::TestCase
  extend AlgoliaSearchable

  context "A Neighborhood" do
    subject { Neighborhood.make }

    it_should_behave_like "being searchable with algolia", Neighborhood, :name

    should_have_neighborhood_listing_image
    should_be_mappable
    should_have_seo_metadata

    should validate_presence_of(:name)
    should validate_presence_of(:latitude)
    should validate_presence_of(:longitude)
    should validate_presence_of(:area)
    should validate_presence_of(:state)

    should validate_uniqueness_of(:name)

    should have_attached_file(:banner_image)
    should validate_attachment_presence(:banner_image)

    should belong_to(:area)
    should belong_to(:state)
    should belong_to(:featured_apartment_community)
    should have_many(:neighborhood_memberships).dependent(:destroy)
    should have_many(:apartment_communities).through(:neighborhood_memberships)

    should have_many(:related_neighborhoods).dependent(:destroy)
    should have_many(:nearby_neighborhoods).through(:related_neighborhoods)
    should have_many(:neighborhood_relations).dependent(:destroy)

    describe "nested structure" do
      before do
        # neighborhood
        #   - community_1
        #     - floor_plan_1
        #   - community_2
        #     - floor_plan_2
        #   - community_3
        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make
        @community_3 = ApartmentCommunity.make

        @floor_plan_1 = ApartmentFloorPlan.make(:apartment_community => @community_1)
        @floor_plan_2 = ApartmentFloorPlan.make(:apartment_community => @community_2)

        subject.apartment_communities = [@community_1, @community_2, @community_3]
        subject.save
      end

      describe "#to_s" do
        it "returns the name" do
          subject.to_s.should == subject.name
        end
      end

      describe "#parent" do
        it "returns the area" do
          subject.parent.should == subject.area
        end
      end

      describe "#children" do
        it "returns nil" do
          subject.children.should == nil
        end
      end

      describe "#lineage" do
        it "returns the metro, area, and the neighborhood" do
          subject.lineage.should == [subject.area.metro, subject.area, subject]
        end
      end

      describe "#lineage_hash" do
        it "returns the hash" do
          subject.lineage_hash.should == {
            :metro        => subject.area.metro,
            :area         => subject.area,
            :neighborhood => subject
          }
        end
      end

      describe "#communities" do
        it "returns all of the unique communities" do
          subject.communities.should == [@community_1, @community_2, @community_3]
        end
      end

      describe "#has_communities?" do
        context "when the neighborhood has communities" do
          it "returns true" do
            subject.has_communities?.should == true
          end
        end

        context "when the mtro does not have any communities" do
          it "returns false" do
            Neighborhood.make.has_communities?.should == false
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

        it "updates the parent area" do
          subject.area.apartment_communities_count.should == 3
        end
      end

      describe "after destroying" do
        it "updates the count on the parent area" do
          area = subject.area
          area.apartment_communities_count.should == 3

          subject.destroy

          area.reload
          area.apartment_communities_count.should == 0
        end
      end
    end

    describe "#nearby_communities" do
      before do
        # nearby_1
        #   - community_1
        #   - community_2
        # nearby_2
        #   - community_1

        @community_1 = ApartmentCommunity.make
        @community_2 = ApartmentCommunity.make

        @nearby_1 = Neighborhood.make
        @nearby_1.apartment_communities << [@community_1, @community_2]

        @nearby_2 = Neighborhood.make
        @nearby_2.apartment_communities << [@community_1]

        subject.nearby_neighborhoods = [@nearby_1, @nearby_2]
        subject.save
      end

      it "returns the nearby communities" do
        subject.nearby_communities.should == [@community_1, @community_2]
      end
    end

    describe "#tier_for" do
      before { @community = ApartmentCommunity.make }

      context "when the given community has a membership with the neighborhood" do
        before do
          @membership = NeighborhoodMembership.make(
            :neighborhood        => subject,
            :apartment_community => @community,
            :tier                => 2
          )
        end

        it "returns the tier" do
          subject.tier_for(@community).should == 2
        end
      end

      context "when the given community does not have a membership with the neighborhood" do
        it "does not raise a NoMethodError" do
          expect { subject.tier_for(@community) }.to_not raise_error
        end
      end
    end

    describe "#tier_1_community_slides" do
      before do
        @subject = Neighborhood.make

        @subject.apartment_communities = (1..4).map do |i|
          instance_variable_set(
            "@community_#{i}",
            ApartmentCommunity.make(:hero_image_file_name => Sham.file_name)
          )
        end

        @community_1.neighborhood_memberships.first.update_attribute(:tier, 1)
        @community_2.neighborhood_memberships.first.update_attribute(:tier, 1)
        @community_3.neighborhood_memberships.first.update_attribute(:tier, 2)
        @community_4.neighborhood_memberships.first.update_attribute(:tier, 3)
      end

      it "returns a slide for each tier 1 community in the neighborhood" do
        slides = @subject.reload.tier_1_community_slides
        slide1 = Bozzuto::Neighborhoods::Slideshow::Slide.new(@community_1)
        slide2 = Bozzuto::Neighborhoods::Slideshow::Slide.new(@community_2)

        slides.should =~ [slide1, slide2]

        slide1.image.should == @community_1.hero_image
      end
    end
  end
end
