require 'test_helper'

class SeoMetadataTest < ActiveSupport::TestCase
  context "SEO Metadata" do
    subject { SeoMetadata.new }

    should_belong_to(:resource)
    should_validate_presence_of(:resource)
  end
end
