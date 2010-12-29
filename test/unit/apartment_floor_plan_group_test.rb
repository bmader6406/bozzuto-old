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
  end
end
