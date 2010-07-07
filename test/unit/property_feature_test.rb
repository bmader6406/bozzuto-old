require 'test_helper'

class PropertyFeatureTest < ActiveSupport::TestCase
  context 'PropertyFeature' do
    setup do
      @feature = PropertyFeature.make
    end

    subject { @feature }

    should_have_and_belong_to_many :properties
    should_have_and_belong_to_many :apartment_communities
    should_have_and_belong_to_many :home_communities

    should_have_attached_file :icon

    should_validate_attachment_presence :icon

    should_validate_uniqueness_of :name
  end
end
