require 'test_helper'

class ApartmentCommunitiesHelperTest < ActionView::TestCase
  context "ApartmentCommunitiesHelper" do
    context '#render_apartments_listings' do
      setup do
        @communities = [ApartmentCommunity.make, ApartmentCommunity.make]
        @options = {
          :partial    => 'apartment_communities/listing',
          :collection => @communities,
          :as         => :community,
          :locals     => { :use_dnr => false }
        }
      end

      context 'and :use_dnr option is not set' do
        should 'call render with the correct options' do
          expects(:render).with(@options)

          render_apartments_listings(@communities)
        end
      end

      context 'and :use_dnr option is true' do
        should 'call render with the correct options' do
          @options[:locals][:use_dnr] = true
          expects(:render).with(@options)

          render_apartments_listings(@communities, :use_dnr => true)
        end
      end
    end

    context "#floor_plan_price" do
      setup do
        @plan = ApartmentFloorPlan.make(:min_effective_rent => 600)
      end

      should "return the floor plan's formatted price" do
        assert_equal "$600", floor_plan_price(@plan.min_effective_rent)
      end
    end

    context '#floor_plan_image' do
      setup do
        @plan = ApartmentFloorPlan.make :image_url => 'http://bozzuto.com/blah.jpg'
      end

      should 'return the link' do
        link = HTML::Document.new(floor_plan_image(@plan))
        assert_select link.root, 'a', :count => 1, :href => @plan
        assert_select link.root, 'img', :count => 1, :src => @plan
      end
    end

    context "#square_feet" do
      setup do
        @plan = ApartmentFloorPlan.make(:min_square_feet => 550)
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

    context '#price_of_cheapest_floor_plan' do
      setup { @group = ApartmentFloorPlanGroup.make }

      context 'there are no floor plans' do
        should 'return empty string' do
          assert_equal '', price_of_cheapest_floor_plan(@group.floor_plans)
        end
      end

      context 'there are floor plans' do
        setup do
          @cheapest = ApartmentFloorPlan.make :floor_plan_group => @group,
            :min_effective_rent => 1000
          @expensive = ApartmentFloorPlan.make :floor_plan_group => @group,
            :min_effective_rent => 2000
        end

        should 'return the price of the cheapest' do
          assert_equal floor_plan_price(@cheapest.min_rent),
            price_of_cheapest_floor_plan(@group.floor_plans)
        end
      end
    end

    context '#square_feet_of_largest_floor_plan' do
      setup { @group = ApartmentFloorPlanGroup.make }

      context 'there are no floor plans' do
        should 'return empty string' do
          assert_equal '', square_feet_of_largest_floor_plan(@group.floor_plans)
        end
      end

      context 'there are floor plans' do
        setup do
          @largest = ApartmentFloorPlan.make :floor_plan_group => @group,
            :max_square_feet => 2000
          @smallest = ApartmentFloorPlan.make :floor_plan_group => @group,
            :max_square_feet => 1000
        end

        should 'return the price of the cheapest' do
          assert_equal square_feet(@largest),
            square_feet_of_largest_floor_plan(@group.floor_plans)
        end
      end
    end
  end
end
