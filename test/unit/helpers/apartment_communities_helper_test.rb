require 'test_helper'

class ApartmentCommunitiesHelperTest < ActionView::TestCase
  context "ApartmentCommunitiesHelper" do
    context "#floor_plan_price" do
      setup do
        @plan = FloorPlan.make(:min_effective_rent => 600)
      end

      should "return the floor plan's formatted price" do
        assert_equal "$600", floor_plan_price(@plan.min_effective_rent)
      end
    end

    context '#floor_plan_image' do
      setup do
        @plan = FloorPlan.make :image_url => 'http://bozzuto.com/blah.jpg'
      end

      should 'return the link' do
        link = HTML::Document.new(floor_plan_image(@plan))
        assert_select link.root, 'a', :count => 1, :href => @plan
        assert_select link.root, 'img', :count => 1, :src => @plan
      end
    end

    context "#square_feet" do
      setup do
        @plan = FloorPlan.make(:min_square_feet => 550)
      end

      should "return the floor plan's formatted square footage" do
        assert_equal "#{@plan.min_square_feet} Sq Ft", square_feet(@plan)
      end
    end

    context '#website_url' do
      should "prepend 'http://' if not present" do
        assert_equal 'http://google.com', website_url('google.com')
        assert_equal 'https://yahoo.com', website_url('https://yahoo.com')
      end
    end

    context "#twitter_data_attr" do
      should "return the twitter username data attribute" do
        assert_equal 'data-twitter-username="vigetlabs"',
          twitter_data_attr('vigetlabs')
      end
    end

    context "#walkscore_map_script" do
      setup do
        @community = ApartmentCommunity.make(:street_address => '123 Test Dr')
      end

      should "return the javascript code" do
        assert_match /#{@community.address}/,
          walkscore_map_script(@community)

        assert_match /var ws_width = '500';/,
          walkscore_map_script(@community, :width => 500)

        assert_match /var ws_height = '700';/,
          walkscore_map_script(@community, :height => 700)
      end
    end
  end
end
