require 'test_helper'

module Bozzuto::ExternalFeed
  class RentCafeTest < ActiveSupport::TestCase
    context "The RentCafe source" do
      before do
        APP_CONFIG[:rent_cafe_feed_file] = "test/files/rent_cafe.xml"
      end

      describe ".queue!" do
        it "creates a PropertyFeedImport" do
          feed = Bozzuto::ExternalFeed::RentCafe.queue!

          feed.persisted?.should == true
        end

        it "sets the correct type" do
          feed = Bozzuto::ExternalFeed::RentCafe.queue!

          feed.type.should == "rent_cafe"
        end
      end

      describe ".imports" do
        before do
          @rent_cafe_import = ::PropertyFeedImport.make(type: "rent_cafe")
          @vaultware_import = ::PropertyFeedImport.make(type: "vaultware")
        end

        it "returns RentCafe PropertyFeedImports" do
          Bozzuto::ExternalFeed::RentCafe.imports.should == [@rent_cafe_import]
        end
      end

      describe ".latest" do
        before do
          @new_import = ::PropertyFeedImport.make(type: "rent_cafe", created_at: 1.minute.ago)
          @old_import = ::PropertyFeedImport.make(type: "rent_cafe", created_at: 1.hour.ago)
        end

        it "returns the import with the latest created_at timestamp" do
          Bozzuto::ExternalFeed::RentCafe.latest.should == @new_import
        end
      end

      describe ".type" do
        it "returns rent_cafe" do
          Bozzuto::ExternalFeed::RentCafe.type.should == "rent_cafe"
        end
      end
    end
  end
end
