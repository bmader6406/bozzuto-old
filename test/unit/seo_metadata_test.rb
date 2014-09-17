require 'test_helper'

class SeoMetadataTest < ActiveSupport::TestCase
  context "SEO Metadata" do
    subject { SeoMetadata.new }

    should belong_to(:resource)
    should validate_presence_of(:resource)
  end
end
