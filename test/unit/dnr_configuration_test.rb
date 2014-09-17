require 'test_helper'

class DnrConfigurationTest < ActiveSupport::TestCase
  context 'A DNR configuration' do
    should belong_to(:property)

    should validate_presence_of(:customer_code)
    should validate_presence_of(:property)
  end
end
