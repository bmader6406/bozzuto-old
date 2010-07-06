require 'test_helper'

class FloorPlanTest < ActiveSupport::TestCase
  context "A floor plan" do
    setup do
      @plan = FloorPlan.new
    end

    should_belong_to :floor_plan_group, :apartment_community

    should_validate_presence_of :name,
      :bedrooms,
      :bathrooms,
      :min_square_feet,
      :max_square_feet,
      :min_market_rent,
      :max_market_rent,
      :min_effective_rent,
      :max_effective_rent,
      :min_rent,
      :max_rent,
      :floor_plan_group,
      :apartment_community

    should_validate_numericality_of :bedrooms,
      :bathrooms,
      :min_square_feet,
      :max_square_feet,
      :min_market_rent,
      :max_market_rent,
      :min_effective_rent,
      :max_effective_rent,
      :min_rent,
      :max_rent

    context '#uses_image_url?' do
      context 'when image_type is USE_IMAGE_URL' do
        setup do
          @plan.image_type = FloorPlan::USE_IMAGE_URL
        end

        should 'return true' do
          assert @plan.uses_image_url?
        end
      end

      context 'when image_type is USE_IMAGE_FILE' do
        setup do
          @plan.image_type = FloorPlan::USE_IMAGE_FILE
        end

        should 'return false' do
          assert !@plan.uses_image_url?
        end
      end
    end

    context '#uses_image_file?' do
      context 'when image_type is USE_IMAGE_URL' do
        setup do
          @plan.image_type = FloorPlan::USE_IMAGE_URL
        end

        should 'return false' do
          assert !@plan.uses_image_file?
        end
      end

      context 'when image_type is USE_IMAGE_FILE' do
        setup do
          @plan.image_type = FloorPlan::USE_IMAGE_FILE
        end

        should 'return true' do
          assert @plan.uses_image_file?
        end
      end
    end

    context '#actual_image' do
      setup do
        @url = 'http://viget.com/booya.jpg'
        @file = '/blah.jpg'
        @plan.image_url = @url
      end

      context 'when image_type is USE_IMAGE_URL' do
        should 'return the image url' do
          @plan.image_type = FloorPlan::USE_IMAGE_URL

          assert_equal @url, @plan.actual_image
        end
      end

      context 'when image_type is USE_IMAGE_FILE' do
        should 'return the image file' do
          @plan.image_type = FloorPlan::USE_IMAGE_FILE
          @plan.image.expects(:url).returns(@file)

          assert_equal @file, @plan.actual_image
        end
      end
    end

    context '#actual_thumb' do
      setup do
        @url = 'http://viget.com/booya.jpg'
        @file = '/blah.jpg'
        @plan.image_url = @url
      end

      context 'when image_type is USE_IMAGE_URL' do
        should 'return the image url' do
          @plan.image_type = FloorPlan::USE_IMAGE_URL

          assert_equal @url, @plan.actual_thumb
        end
      end

      context 'when image_type is USE_IMAGE_FILE' do
        should 'return the image file' do
          @plan.image_type = FloorPlan::USE_IMAGE_FILE
          @plan.image.expects(:url).with(:thumb).returns(@file)

          assert_equal @file, @plan.actual_thumb
        end
      end
    end

    context '#scope_condition' do
      should 'scope by community id and floor plan group id' do
        condition = "apartment_community_id = #{@plan.apartment_community_id} AND floor_plan_group_id = #{@plan.floor_plan_group_id}"

        assert_equal condition, @plan.send(:scope_condition)
      end
    end

    context 'before validating' do
      setup do
        @community = ApartmentCommunity.make
        @plan = FloorPlan.make(
          :min_market_rent     => 100,
          :max_market_rent     => 200,
          :min_effective_rent  => 300,
          :max_effective_rent  => 400,
          :apartment_community => @community
        )
        @community.reload
      end

      context 'and community is not using market prices' do
        setup do
          @community.use_market_prices = false
          @community.save

          @plan.reload
          @plan.save
        end

        should 'cache effective rents' do
          assert_equal @plan.min_effective_rent, @plan.min_rent
          assert_equal @plan.max_effective_rent, @plan.max_rent
        end
      end

      context 'and community is using market prices' do
        setup do
          @community.use_market_prices = true
          @community.save

          @plan.reload
          @plan.save
        end

        should 'cache market rents' do
          assert_equal @plan.min_market_rent, @plan.min_rent
          assert_equal @plan.max_market_rent, @plan.max_rent
        end
      end
    end

    context '#cheapest and #largest named scopes' do
      setup do
        @community = ApartmentCommunity.make
        @largest = @community.floor_plans.make({
          :min_market_rent    => 2000,
          :min_effective_rent => 2000,
          :max_square_feet    => 800
        })
        @cheapest_market = @community.floor_plans.make({
          :min_market_rent    => 800,
          :min_effective_rent => 1000,
          :max_square_feet    => 400
        })
        @cheapest_effective = @community.floor_plans.make({
          :min_market_rent    => 1000,
          :min_effective_rent => 800,
          :max_square_feet    => 400
        })
      end

      should "be able to find the largest floor plan" do
        assert_equal @largest, @community.floor_plans.largest.first
      end
 
      context 'when not using market prices' do
        setup do
          @community.use_market_prices = false
          @community.save
          @community.floor_plans.reload
        end

        should 'be able to find the cheapest floor plan by effective rent' do
          assert_equal @cheapest_effective, @community.floor_plans.cheapest.first
        end
      end
 
      context 'when using market prices' do
        setup do
          @community.use_market_prices = true
          @community.save
          @community.reload
        end
 
        should 'be able to find the cheapest floor plan by market rent' do
          assert_equal @cheapest_market, @community.floor_plans.cheapest.first
        end
      end
    end
  end
end
