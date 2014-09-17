require 'test_helper'

class ConversionConfigurationTest < ActiveSupport::TestCase
  context 'A Conversion Configuration' do
    should belong_to(:property)

    should validate_presence_of(:name)
    should validate_presence_of(:property)
  end
end
