
require 'test_helper'

module Bozzuto::ExternalFeed
  class PropertyAmenityTest < ActiveSupport::TestCase
    context "PropertyAmenity" do
      subject do
        Bozzuto::ExternalFeed::PropertyAmenity.new(
          :primary_type => 'ClubHouse',
          :sub_type     => 'Attached',
          :description  => 'Party time.',
          :position     => 1
        )
      end

      describe "#database_attributes" do
        it "returns a hash of attributes" do
          subject.database_attributes.should == {
            :primary_type => 'ClubHouse',
            :sub_type     => 'Attached',
            :description  => 'Party time.',
            :position     => 1
          }
        end
      end
    end
  end
end
