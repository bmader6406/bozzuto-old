require 'test_helper'

class ApartmentFloorPlanGroupTest < ActiveSupport::TestCase
  context "ApartmentFloorPlanGroup" do
    setup do
      create_floor_plan_groups
    end

    should_have_many :floor_plans

    should_validate_presence_of :name

    context 'named scopes' do
      context ':except' do
        setup do
          @all    = ApartmentFloorPlanGroup.all
          @studio = ApartmentFloorPlanGroup.studio
        end

        should 'return all except the parameter' do
          assert_equal @all - [@studio], ApartmentFloorPlanGroup.except(@studio)
        end
      end
    end

    context 'custom names' do
      setup do
        @studio    = ApartmentFloorPlanGroup.studio
        @bedroom   = ApartmentFloorPlanGroup.one_bedroom
        @bedrooms2 = ApartmentFloorPlanGroup.two_bedrooms
        @bedrooms3 = ApartmentFloorPlanGroup.three_bedrooms
        @penthouse = ApartmentFloorPlanGroup.penthouse
        @other     = ApartmentFloorPlanGroup.make(:name => 'Hooray')
      end

      context '#list_name' do
        should 'use "Studios" for Studio' do
          assert_equal 'Studios', @studio.list_name
        end

        should 'use "1BR" for 1 Bedroom' do
          assert_equal '1BR', @bedroom.list_name
        end

        should 'use "2BR" for 2 Bedrooms' do
          assert_equal '2BR', @bedrooms2.list_name
        end

        should 'use "3BR" for 3 or More Bedrooms' do
          assert_equal '3BR', @bedrooms3.list_name
        end

        should 'use "Penthouses" for Penthouse' do
          assert_equal 'Penthouses', @penthouse.list_name
        end
      end

      context '#name_for_cache' do
        should 'use "studio" for Studio' do
          assert_equal 'studio', @studio.name_for_cache
        end

        should 'use "1_bedroom" for 1 Bedroom' do
          assert_equal '1_bedroom', @bedroom.name_for_cache
        end

        should 'use "2_bedroom" for 2 Bedrooms' do
          assert_equal '2_bedroom', @bedrooms2.name_for_cache
        end

        should 'use "3_bedroom" for 3 or More Bedrooms' do
          assert_equal '3_bedroom', @bedrooms3.name_for_cache
        end

        should 'use "penthouse" for Penthouse' do
          assert_equal 'penthouse', @penthouse.name_for_cache
        end

        should 'raise on anything else' do
          assert_raises(RuntimeError) { @other.name_for_cache }
        end
      end
    end
  end
end
