require 'test_helper'

module Bozzuto::ExternalFeed
  class PsiTest < ActiveSupport::TestCase
    context "The Psi source" do
      before do
        APP_CONFIG[:psi_feed_file] = "test/files/psi.xml"
      end

      describe ".queue!" do
        it "creates a PropertyFeedImport" do
          feed = Bozzuto::ExternalFeed::Psi.queue!

          feed.persisted?.should == true
        end

        it "sets the correct type" do
          feed = Bozzuto::ExternalFeed::Psi.queue!

          feed.type.should == "psi"
        end
      end

      describe ".imports" do
        before do
          @psi_import       = ::PropertyFeedImport.make(type: "psi")
          @vaultware_import = ::PropertyFeedImport.make(type: "vaultware")
        end

        it "returns Psi PropertyFeedImports" do
          Bozzuto::ExternalFeed::Psi.imports.should == [@psi_import]
        end
      end

      describe ".latest" do
        before do
          @new_import = ::PropertyFeedImport.make(type: "psi", created_at: 1.minute.ago)
          @old_import = ::PropertyFeedImport.make(type: "psi", created_at: 1.hour.ago)
        end

        it "returns the import with the latest created_at timestamp" do
          Bozzuto::ExternalFeed::Psi.latest.should == @new_import
        end
      end

      describe ".type" do
        it "returns psi" do
          Bozzuto::ExternalFeed::Psi.type.should == "psi"
        end
      end
    end
  end
end
