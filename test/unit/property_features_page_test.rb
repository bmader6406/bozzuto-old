require 'test_helper'

class PropertyFeaturesPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should_belong_to :property
    should_validate_presence_of :property_id
  end
end
