require 'test_helper'

module Bozzuto::ExternalFeed
  class FloorPlanTest < ActiveSupport::TestCase
    context "A FloorPlan" do
      subject do
        Bozzuto::ExternalFeed::FloorPlan.new(
          :name              => 'Name',
          :external_cms_id   => 'External CMS ID',
          :external_cms_type => 'External CMS Type',
          :floor_plan_group  => 'Floor Plan Group',
          :availability_url  => 'Availability URL',
          :available_units   => 'Available Units',
          :bedrooms          => 'Bedrooms',
          :bathrooms         => 'Bathrooms',
          :min_square_feet   => 'Min Square Feet',
          :max_square_feet   => 'Max Square Feet',
          :min_rent          => 'Min Rent',
          :max_rent          => 'Max Rent',
          :image_url         => 'Image URL',
          :unit_count        => 15
        )
      end

      describe "#database_attributes" do
        it "returns a hash of attributes" do
          subject.database_attributes.should == {
            :name              => 'Name',
            :external_cms_id   => 'External CMS ID',
            :external_cms_type => 'External CMS Type',
            :availability_url  => 'Availability URL',
            :available_units   => 'Available Units',
            :bedrooms          => 'Bedrooms',
            :bathrooms         => 'Bathrooms',
            :min_square_feet   => 'Min Square Feet',
            :max_square_feet   => 'Max Square Feet',
            :min_rent          => 'Min Rent',
            :max_rent          => 'Max Rent',
            :image_url         => 'Image URL',
            :unit_count        => 15
          }
        end
      end
    end
  end
end
