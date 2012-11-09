require 'test_helper'

class HomeCommunityTest < ActiveSupport::TestCase
  context 'HomeCommunity' do
    setup do
      @community = HomeCommunity.make
    end

    subject { @community }

    should_have_many :homes
    should_have_many :featured_homes
    should_have_attached_file :listing_promo
    should_have_one :lasso_account
    
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
