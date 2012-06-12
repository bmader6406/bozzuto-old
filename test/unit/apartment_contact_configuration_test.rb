require 'test_helper'

class ApartmentContactConfigurationTest < ActiveSupport::TestCase
  context 'Apartment Contact Configuration' do
    should_validate_presence_of(:apartment_community)
  end
end
