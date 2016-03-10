require 'test_helper'

class PropertyNeighborhoodPageTest < ActiveSupport::TestCase
  context 'PropertyNeighborhoodPage' do
    should belong_to(:property)

    should validate_presence_of(:property)
  end
end
