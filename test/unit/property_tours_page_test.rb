require 'test_helper'

class PropertyToursPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should belong_to(:property)

    should validate_presence_of(:property)
    should validate_presence_of(:title)
  end
end
