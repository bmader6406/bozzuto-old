require 'test_helper'

class ConversionConfigurationTest < ActiveSupport::TestCase
  context 'A Conversion Configuration' do
    should_belong_to :property
    should_validate_presence_of :name, :property
  end
end
