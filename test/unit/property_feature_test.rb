require 'test_helper'

class PropertyFeatureTest < ActiveSupport::TestCase
  context 'PropertyFeature' do
    subject { PropertyFeature.make }

    should have_and_belong_to_many(:properties)
    should have_and_belong_to_many(:apartment_communities)
    should have_and_belong_to_many(:home_communities)

    should have_attached_file(:icon)

    should validate_uniqueness_of(:name)
  end
end
