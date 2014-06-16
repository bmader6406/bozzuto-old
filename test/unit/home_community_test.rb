require 'test_helper'

class HomeCommunityTest < ActiveSupport::TestCase
  context 'HomeCommunity' do
    setup do
      @community = HomeCommunity.make
    end

    subject { @community }

    should_have_neighborhood_listing_image(:neighborhood_listing_image, :required => false)

    should_have_many :homes
    should_have_many :featured_homes
    should_have_attached_file :listing_promo
    should_have_one :lasso_account
    should_have_one :green_package
    should_have_one :neighborhood
    should_have_many :home_neighborhood_memberships
    
    should 'be archivable' do
      assert HomeCommunity.acts_as_archive?
      assert_nothing_raised do
        HomeCommunity::Archive
      end
      assert defined?(HomeCommunity::Archive)
      assert HomeCommunity::Archive.ancestors.include?(ActiveRecord::Base)
      assert HomeCommunity::Archive.ancestors.include?(Property::Archive)
      assert HomeCommunity::Archive.ancestors.include?(Community::Archive)
    end

    describe "callbacks" do
      before do
        @neighborhood = HomeNeighborhood.make(:home_communities => [subject, HomeCommunity.make])
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

            subject.update_attributes(:published => false)

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
        @communities = 3.times.collect do |i|
          HomeCommunity.make(:latitude => i, :longitude => i, :city => @city)
        end

        @unpublished = HomeCommunity.make(:unpublished,
                                          :latitude  => 4,
                                          :longitude => 1,
                                          :city      => @city)
        @communities << @unpublished

        @nearby = @communities[0].nearby_communities
      end

      should 'return the closest communities' do
        assert_equal 2, @nearby.length
        assert_equal @communities[1], @nearby[0]
        assert_equal @communities[2], @nearby[1]
      end

      should 'return only published communities' do
        assert_does_not_contain @nearby, @unpublished
      end
    end

    context '#show_lasso_form?' do
      context 'lasso account relationship is present' do
        setup do
          @community.create_lasso_account({
            :uid        => 'blah',
            :client_id  => 'blah',
            :project_id => 'blah'
          })
        end

        should 'return true' do
          assert @community.show_lasso_form?
        end
      end

      context 'lasso account relationship is not present' do
        should 'return false' do
          assert !@community.show_lasso_form?
        end
      end
    end

    context "#apartment_community?" do
      setup do
        @community = HomeCommunity.new
      end

      should "return false" do
        assert !@community.apartment_community?
      end
    end

    context "#home_community?" do
      setup do
        @community = HomeCommunity.new
      end

      should "return true" do
        assert @community.home_community?
      end
    end
  end
end
