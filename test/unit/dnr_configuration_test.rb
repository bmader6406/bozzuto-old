require 'test_helper'

class DnrConfigurationTest < ActiveSupport::TestCase
  context 'A DNR configuration' do
    should_belong_to :property
    should_validate_presence_of :customer_code, :property
  end
end
