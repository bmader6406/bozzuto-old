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
      context 'all three lasso fields are present' do
        setup do
          @community.lasso_uid        = 'blah'
          @community.lasso_client_id  = 'blah'
          @community.lasso_project_id = 'blah'
        end

        should 'return true' do
          assert @community.show_lasso_form?
        end
      end

      context 'some lasso fields are not present' do
        setup { @community.lasso_uid = 'blah' }

        should 'return false' do
          assert !@community.show_lasso_form?
        end
      end
    end
  end
end
