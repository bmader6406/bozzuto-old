require 'test_helper'

class ConversionConfigurationTest < ActiveSupport::TestCase
  context 'A Conversion Configuration' do

    should belong_to(:home_community)

    should validate_presence_of(:name)
    should validate_presence_of(:home_community_id)
  end
end
