require 'test_helper'

module Bozzuto::ExternalFeed
  class PropertyLinkTest < ActiveSupport::TestCase
    context "The PropertyLink source" do
      before do
        APP_CONFIG[:property_link_feed_file] = "test/files/property_link.xml"
      end

      describe ".queue!" do
        it "creates a PropertyFeedImport" do
          feed = Bozzuto::ExternalFeed::PropertyLink.queue!

          feed.persisted?.should == true
        end

        it "sets the correct type" do
          feed = Bozzuto::ExternalFeed::PropertyLink.queue!

          feed.type.should == "property_link"
        end
      end

      describe ".imports" do
        before do
          @property_link_import = ::PropertyFeedImport.make(type: "property_link")
          @vaultware_import     = ::PropertyFeedImport.make(type: "vaultware")
        end

        it "returns PropertyLink PropertyFeedImports" do
          Bozzuto::ExternalFeed::PropertyLink.imports.should == [@property_link_import]
        end
      end

      describe ".latest" do
        before do
          @new_import = ::PropertyFeedImport.make(type: "property_link", created_at: 1.minute.ago)
          @old_import = ::PropertyFeedImport.make(type: "property_link", created_at: 1.hour.ago)
        end

        it "returns the import with the latest created_at timestamp" do
          Bozzuto::ExternalFeed::PropertyLink.latest.should == @new_import
        end
      end

      describe ".type" do
        it "returns property_link" do
          Bozzuto::ExternalFeed::PropertyLink.type.should == "property_link"
        end
      end
    end
  end
end
