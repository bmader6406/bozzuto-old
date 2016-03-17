require 'test_helper'

module Bozzuto::ExternalFeed
  class VaultwareTest < ActiveSupport::TestCase
    context "The Vaultware source" do
      before do
        APP_CONFIG[:vaultware_feed_file] = "test/files/vaultware.xml"
      end

      describe ".queue!" do
        it "creates a PropertyFeedImport" do
          feed = Bozzuto::ExternalFeed::Vaultware.queue!

          feed.persisted?.should == true
        end

        it "sets the correct type" do
          feed = Bozzuto::ExternalFeed::Vaultware.queue!

          feed.type.should == "vaultware"
        end
      end

      describe ".imports" do
        before do
          @vaultware_import = ::PropertyFeedImport.make(type: "vaultware")
          @psi_import       = ::PropertyFeedImport.make(type: "psi")
        end

        it "returns Vaultware PropertyFeedImports" do
          Bozzuto::ExternalFeed::Vaultware.imports.should == [@vaultware_import]
        end
      end

      describe ".latest" do
        before do
          @new_import = ::PropertyFeedImport.make(type: "vaultware", created_at: 1.minute.ago)
          @old_import = ::PropertyFeedImport.make(type: "vaultware", created_at: 1.hour.ago)
        end

        it "returns the import with the latest created_at timestamp" do
          Bozzuto::ExternalFeed::Vaultware.latest.should == @new_import
        end
      end

      describe ".type" do
        it "returns vaultware" do
          Bozzuto::ExternalFeed::Vaultware.type.should == "vaultware"
        end
      end
    end
  end
end
