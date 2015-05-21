require 'test_helper'

module Bozzuto::ExternalFeed
  class PropertyImporterTest < ActiveSupport::TestCase
    context "A PropertyImporter" do
      before do
        @property_date_object = nil
      end

      subject do
        Bozzuto::ExternalFeed::PropertyImporter.new(@property_data_object)
      end

      describe "#import" do
        it "does all the things" do
        end
      end
    end
  end
end
