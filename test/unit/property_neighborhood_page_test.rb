require 'test_helper'

class PropertyNeighborhoodPageTest < ActiveSupport::TestCase
  context 'PropertyNeighborhoodPage' do
    should_belong_to :property, :apartment_community, :home_community, :project
    should_validate_presence_of :property_id
  end
end
