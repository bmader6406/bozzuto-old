require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  context 'Home' do
    subject { Home.make }

    should belong_to(:home_community)
    should have_many(:floor_plans)

    should accept_nested_attributes_for(:floor_plans)

    should validate_presence_of(:home_community)
    should validate_presence_of(:bedrooms)
    should validate_presence_of(:bathrooms)

    should validate_numericality_of(:bedrooms)
    should validate_numericality_of(:bathrooms)
    should validate_numericality_of(:square_feet)
  end
end
