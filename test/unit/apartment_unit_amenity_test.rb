require 'test_helper'

class ApartmentUnitAmenityTest < ActiveSupport::TestCase
  context "ApartmentUnitAmenity" do
    should belong_to(:apartment_unit)

    should validate_presence_of(:apartment_unit)
    should validate_presence_of(:primary_type)

    ApartmentUnitAmenity::PRIMARY_TYPE.each do |type|
      should allow_value(type).for(:primary_type)
      should_not allow_value(type).for(:sub_type)
    end

    ApartmentUnitAmenity::SUB_TYPE.each do |type|
      should allow_value(type).for(:sub_type)
      should_not allow_value(type).for(:primary_type)
    end

    should allow_value(nil).for(:sub_type)
  end
end
