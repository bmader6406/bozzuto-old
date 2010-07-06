require 'test_helper'

class PropertyFeatureTest < ActiveSupport::TestCase
  context 'PropertyFeature' do
    should_have_attached_file :icon

    should_have_and_belong_to_many :properties
    should_have_and_belong_to_many :apartment_communities
    should_have_and_belong_to_many :home_communities

    should_validate_attachment_presence :icon
  end
end
