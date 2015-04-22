require 'test_helper'

class PropertyAmenityTest < ActiveSupport::TestCase
  context "PropertyAmenity" do
    should belong_to(:property)

    should validate_presence_of(:property)
    should validate_presence_of(:primary_type)

    PropertyAmenity::PRIMARY_TYPE.each do |type|
      should allow_value(type).for(:primary_type)
      should_not allow_value(type).for(:sub_type)
    end

    PropertyAmenity::SUB_TYPE.each do |type|
      should allow_value(type).for(:sub_type)
      should_not allow_value(type).for(:primary_type)
    end

    should allow_value(nil).for(:sub_type)
  end
end
