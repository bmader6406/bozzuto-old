require 'test_helper'

class ApartmentContactConfigurationTest < ActiveSupport::TestCase
  context 'Apartment Contact Configuration' do
    should belong_to(:apartment_community)
    should validate_presence_of(:apartment_community)
  end
end
