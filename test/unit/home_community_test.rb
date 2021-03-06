require 'test_helper'

class HomeCommunityTest < ActiveSupport::TestCase
  extend AlgoliaSearchable

  context 'HomeCommunity' do
    subject { HomeCommunity.make }

    should_have_neighborhood_listing_image(:neighborhood_listing_image, required: false)

    it_should_behave_like "being searchable with algolia", HomeCommunity, :title

    should have_many(:homes)
    should have_many(:featured_homes)

    should have_many(:home_neighborhoods)
    should have_many(:home_neighborhood_memberships)

    should have_one(:conversion_configuration)
    should have_one(:lasso_account)
    should have_one(:green_package)
    should have_one(:neighborhood)

    should have_attached_file(:listing_promo)
    
    should accept_nested_attributes_for(:conversion_configuration)

    describe "callbacks" do
      before do
        @neighborhood = HomeNeighborhood.make
        @neighborhood.home_communities << [subject, HomeCommunity.make]
      end

      describe "after saving" do
        context "when its published flag is not changed" do
          it "does not update the count on its associated areas and neighborhoods" do
            @neighborhood.home_communities_count.should == 2

            subject.save!

            @neighborhood.reload.home_communities_count.should == 2
          end
        end

        context "when its published flag is changed" do
          it "updates the count on its associated areas and neighborhoods" do
            @neighborhood.home_communities_count.should == 2

            subject.update_attributes(published: false)

            @neighborhood.reload.home_communities_count.should == 1
          end
        end
      end

      describe "after deletion" do
        it "updates the count on its associated areas and neighborhoods" do
          @neighborhood.home_communities_count.should == 2

          subject.destroy

          @neighborhood.reload.home_communities_count.should == 1
        end
      end
    end

    context '#nearby_communities' do
      setup do
        @city = City.make

        @community = HomeCommunity.make(latitude: 0, longitude: 0, city: @city)

        @nearby = (1..2).to_a.map do |i|
          HomeCommunity.make(latitude: i, longitude: i, city: @city)
        end

        @unpublished = HomeCommunity.make(:unpublished,
          latitude:  2,
          longitude: 2,
          city:      @city
        )
      end

      should 'return the closest communities' do
        @community.nearby_communities.should == @nearby
      end
    end

    context '#show_lasso_form?' do
      context 'lasso account relationship is present' do
        setup do
          subject.create_lasso_account(
            uid:        'blah',
            client_id:  'blah',
            project_id: 'blah'
          )
        end

        should 'return true' do
          subject.show_lasso_form?.should == true
        end
      end

      context 'lasso account relationship is not present' do
        should 'return false' do
          subject.show_lasso_form?.should == false
        end
      end
    end

    context "#apartment_community?" do
      should "return false" do
        subject.apartment_community?.should == false
      end
    end

    context "#home_community?" do
      should "return true" do
        subject.home_community?.should == true
      end
    end

    context "#project?" do
      should "return false" do
        subject.project?.should == false
      end
    end

    describe "#first_home_neighborhood" do
      setup do
        @neighborhood = HomeNeighborhood.make
        @neighborhood.home_communities << [subject, HomeCommunity.make]

        @other_hood = HomeNeighborhood.make
        @other_hood.home_communities << [subject, HomeCommunity.make]
      end

      should "return its first home neighborhood" do
        subject.first_home_neighborhood.should == @neighborhood
      end
    end

    describe "#project?" do
      it "returns false" do
        subject.project?.should == false
      end
    end

    describe "#apartment_community?" do
      it "returns false" do
        subject.apartment_community?.should == false
      end
    end

    describe "#home_community?" do
      it "returns true" do
        subject.home_community?.should == true
      end
    end
  end
end
