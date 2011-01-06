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
        @communities = []

        3.times do |i|
          @communities << HomeCommunity.make(:latitude => i, :longitude => i, :city => @city)
        end
      end

      should 'return the closest communities' do
        nearby = @communities[0].nearby_communities
        assert_equal 2, nearby.length
        assert_equal @communities[1], nearby[0]
        assert_equal @communities[2], nearby[1]
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
  end
end
