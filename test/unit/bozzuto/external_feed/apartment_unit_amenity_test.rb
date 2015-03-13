require 'test_helper'

module Bozzuto::ExternalFeed
  class ApartmentUnitAmenityTest < ActiveSupport::TestCase
    context "ApartmentUnitAmenity" do
      subject do
        Bozzuto::ExternalFeed::ApartmentUnitAmenity.new(
          :primary_type => 'Heat',
          :sub_type     => 'Central',
          :description  => 'So h0t.  Such l33t.',
          :rank         => 1
        )
      end

      describe "#database_attributes" do
        it "returns a hash of attributes" do
          subject.database_attributes.should == {
            :primary_type => 'Heat',
            :sub_type     => 'Central',
            :description  => 'So h0t.  Such l33t.',
            :rank         => 1
          }
        end
      end
    end
  end
end
