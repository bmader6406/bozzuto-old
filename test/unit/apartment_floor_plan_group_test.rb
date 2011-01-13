require 'test_helper'

class ApartmentFloorPlanGroupTest < ActiveSupport::TestCase
  context "ApartmentFloorPlanGroup" do
    setup do
      @group = ApartmentFloorPlanGroup.make
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
    
    context '#list_name' do
      setup do
        @studio = ApartmentFloorPlanGroup.make(:name => 'Studio')
        @bedroom = ApartmentFloorPlanGroup.make(:name => '1 Bedroom')
        @bedrooms2 = ApartmentFloorPlanGroup.make(:name => '2 Bedrooms')
        @bedrooms3 = ApartmentFloorPlanGroup.make(:name => '3 or More Bedrooms')
        @penthouse = ApartmentFloorPlanGroup.make(:name => 'Penthouse')
      end
      
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
  end
end
