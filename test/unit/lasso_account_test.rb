require 'test_helper'

class LassoAccountTest < ActiveSupport::TestCase
  context 'LassoAccount' do
    should belong_to(:property)

    should validate_presence_of(:property_id)
    should validate_presence_of(:uid)
    should validate_presence_of(:client_id)
    should validate_presence_of(:project_id)
  end
end
