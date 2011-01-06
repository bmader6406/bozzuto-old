require 'test_helper'

class PropertyContactPageTest < ActiveSupport::TestCase
  context 'PropertyContactPage' do
    should_belong_to :property
    should_validate_presence_of :property_id
  end
end
