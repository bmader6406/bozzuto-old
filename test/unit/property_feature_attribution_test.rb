require 'test_helper'

class PropertyFeatureAttributionTest < ActiveSupport::TestCase
  context "PropertyFeatureAttribution" do
    should belong_to(:property)
    should belong_to(:property_feature)

    should validate_presence_of(:property)
    should validate_presence_of(:property_feature)
  end
end
