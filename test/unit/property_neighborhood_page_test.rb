require 'test_helper'

class PropertyNeighborhoodPageTest < ActiveSupport::TestCase
  context 'PropertyNeighborhoodPage' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)
    should belong_to(:project)

    should validate_presence_of(:property_id)
  end
end
