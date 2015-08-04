require 'test_helper'

module Bozzuto::ExternalFeed
  class PropertyTest < ActiveSupport::TestCase
    context "A Property" do
      subject do
        Bozzuto::ExternalFeed::Property.new(
          :title                  => 'Title',
          :street_address         => 'Street Address',
          :city                   => 'City',
          :state                  => 'State',
          :availability_url       => 'Availability URL',
          :office_hours           => 'Office Hours',
          :external_cms_id        => 'External CMS ID',
          :external_cms_type      => 'External CMS Type',
          :external_management_id => 'External Management ID',
          :unit_count             => 150,
          :floor_plans            => 'Floor Plans',
          :property_amenities     => 'Property Amenities'
        )
      end

      describe "#database_attributes" do
        it "returns a hash of attributes" do
          subject.database_attributes.should == {
            :title                  => 'Title',
            :street_address         => 'Street Address',
            :availability_url       => 'Availability URL',
            :external_cms_id        => 'External CMS ID',
            :external_cms_type      => 'External CMS Type',
            :external_management_id => 'External Management ID',
            :unit_count             => 150
          }
        end
      end
    end
  end
end
