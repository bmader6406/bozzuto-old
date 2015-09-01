require 'test_helper'

module Bozzuto::ExternalFeed
  class OccupancyParsersTest < ActiveSupport::TestCase
    context "The OccupancyParsers module" do
      describe ".for" do
        context "given a standard feed" do
          it "returns the appropriate parser" do
            OccupancyParsers.for(:vaultware).should == OccupancyParsers::StandardParser
          end
        end

        context "given Rent Cafe" do
          it "returns the appropriate parser" do
            OccupancyParsers.for(:rent_cafe).should == OccupancyParsers::RentCafe
          end
        end

        context "given Property Link" do
          it "returns the appropriate parser" do
            OccupancyParsers.for(:property_link).should == OccupancyParsers::PropertyLink
          end
        end
      end
    end
  end
end
