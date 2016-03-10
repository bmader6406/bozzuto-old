require 'test_helper'

class PropertyContactPageTest < ActiveSupport::TestCase
  context 'PropertyContactPage' do
    should belong_to(:property)

    should validate_presence_of(:property)
  end
end
