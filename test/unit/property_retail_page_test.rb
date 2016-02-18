require 'test_helper'

class PropertyRetailPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)
    should belong_to(:project)

    should validate_presence_of(:property_id)
  end
end
