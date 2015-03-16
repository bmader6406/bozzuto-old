require 'test_helper'

module Bozzuto::ExternalFeed
  class ApartmentUnitTest < ActiveSupport::TestCase
    context "ApartmentUnit" do
      subject do
        Bozzuto::ExternalFeed::ApartmentUnit.new(
          :external_cms_id              => 'External CMS ID',
          :external_cms_type            => 'External CMS Type',
          :building_external_cms_id     => 'Building External CMS ID',
          :floorplan_external_cms_id    => 'Floorplan External CMS ID',
          :organization_name            => 'Organization Name',
          :marketing_name               => 'Marketing Name',
          :unit_type                    => 'Unit Type',
          :bedrooms                     => 'Bedrooms',
          :bathrooms                    => 'Bathrooms',
          :min_square_feet              => 'Minimum Square Feet',
          :max_square_feet              => 'Maximum Square Feet',
          :square_foot_type             => 'Square Foot Type',
          :unit_rent                    => 'Unit Rent',
          :market_rent                  => 'Market Rent',
          :economic_status              => 'Economic Status',
          :economic_status_description  => 'Economic Status Descriptino',
          :occupancy_status             => 'Occupancy Status',
          :occupancy_status_description => 'Occupancy Status Description',
          :leased_status                => 'Leased Status',
          :leased_status_description    => 'Leased Status Description',
          :number_occupants             => 'Number Occupants',
          :floor_plan_name              => 'Floor Plan Name',
          :phase_name                   => 'Phase Name',
          :building_name                => 'Building Name',
          :primary_property_id          => 'Primary Property ID',
          :address_line_1               => 'Address Line 1',
          :address_line_2               => 'Address Line 2',
          :city                         => 'City',
          :state                        => 'State',
          :zip                          => 'Zip',
          :comment                      => 'Comment',
          :min_rent                     => 'Minimum Rent',
          :max_rent                     => 'Maximum Rent',
          :avg_rent                     => 'Average Rent',
          :vacate_date                  => 'Vacate Date',
          :vacancy_class                => 'Vacancy Class',
          :made_ready_date              => 'Made Ready Date',
          :availability_url             => 'Availability URL'
        )
      end

      describe "#database_attributes" do
        it "returns a hash of attributes" do
          subject.database_attributes.should == {
            :external_cms_id              => 'External CMS ID',
            :external_cms_type            => 'External CMS Type',
            :building_external_cms_id     => 'Building External CMS ID',
            :floorplan_external_cms_id    => 'Floorplan External CMS ID',
            :organization_name            => 'Organization Name',
            :marketing_name               => 'Marketing Name',
            :unit_type                    => 'Unit Type',
            :bedrooms                     => 'Bedrooms',
            :bathrooms                    => 'Bathrooms',
            :min_square_feet              => 'Minimum Square Feet',
            :max_square_feet              => 'Maximum Square Feet',
            :square_foot_type             => 'Square Foot Type',
            :unit_rent                    => 'Unit Rent',
            :market_rent                  => 'Market Rent',
            :economic_status              => 'Economic Status',
            :economic_status_description  => 'Economic Status Descriptino',
            :occupancy_status             => 'Occupancy Status',
            :occupancy_status_description => 'Occupancy Status Description',
            :leased_status                => 'Leased Status',
            :leased_status_description    => 'Leased Status Description',
            :number_occupants             => 'Number Occupants',
            :floor_plan_name              => 'Floor Plan Name',
            :phase_name                   => 'Phase Name',
            :building_name                => 'Building Name',
            :primary_property_id          => 'Primary Property ID',
            :address_line_1               => 'Address Line 1',
            :address_line_2               => 'Address Line 2',
            :city                         => 'City',
            :state                        => 'State',
            :zip                          => 'Zip',
            :comment                      => 'Comment',
            :min_rent                     => 'Minimum Rent',
            :max_rent                     => 'Maximum Rent',
            :avg_rent                     => 'Average Rent',
            :vacate_date                  => 'Vacate Date',
            :vacancy_class                => 'Vacancy Class',
            :made_ready_date              => 'Made Ready Date',
            :availability_url             => 'Availability URL'
          }
        end
      end
    end
  end
end
