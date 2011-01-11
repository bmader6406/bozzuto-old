require 'test_helper'

class PropertyFeaturesPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should_belong_to :property, :apartment_community, :home_community, :project
    should_validate_presence_of :property_id
  end
end
