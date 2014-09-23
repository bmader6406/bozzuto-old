require 'test_helper'

module Bozzuto::ExternalFeed
  class CarmelFeedTest < ActiveSupport::TestCase
    context "A CarmelFeed" do
      subject { Bozzuto::ExternalFeed::CarmelFeed.new(Rails.root.join('test/files/carmel.xml')) }

      describe "#feed_name" do
        it "returns 'Carmel'" do
          subject.feed_name.should == 'Carmel'
        end
      end

      describe "#properties" do
        it "returns the correct properties" do
          subject.properties.count.should == 2

          subject.properties[0].tap do |c|
            c.title.should             == 'Spectrum'
            c.external_cms_id.should   == 'CHE801'
            c.external_cms_type.should == 'carmel'
            c.floor_plans.count.should == 4

            c.floor_plans[0].tap do |f|
              f.name.should              == 'The Crimson'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=CHE801'
              f.available_units.should   == 1
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 815
              f.max_square_feet.should   == 815
              f.min_rent.should          == 1475.0000
              f.max_rent.should          == 1475.0000
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == 'CRIMS'
              f.external_cms_type.should == 'carmel'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == 'The Umber'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=CHE801'
              f.available_units.should   == 1
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 415
              f.max_square_feet.should   == 415
              f.min_rent.should          == 1360.0000
              f.max_rent.should          == 1360.0000
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == 'FPUMB'
              f.external_cms_type.should == 'carmel'
            end

            c.floor_plans[2].tap do |f|
              f.name.should              == 'The Indigo'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=CHE801'
              f.available_units.should   == 1
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 710
              f.max_square_feet.should   == 710
              f.min_rent.should          == 1405.0000
              f.max_rent.should          == 1405.0000
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == 'INDIG'
              f.external_cms_type.should == 'carmel'
            end

            c.floor_plans[3].tap do |f|
              f.name.should              == 'The Verde'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=CHE801'
              f.available_units.should   == 1
              f.bedrooms.should          == 2
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 980
              f.max_square_feet.should   == 980
              f.min_rent.should          == 1705.0000
              f.max_rent.should          == 1715.0000
              f.floor_plan_group.should  == 'two_bedrooms'
              f.external_cms_id.should   == 'VERDE'
              f.external_cms_type.should == 'carmel'
            end
          end

          subject.properties[1].tap do |c|
            c.title.should             == 'Summit'
            c.external_cms_id.should   == 'SUM822'
            c.external_cms_type.should == 'carmel'
            c.floor_plans.count.should == 3

            c.floor_plans[0].tap do |f|
              f.name.should              == 'Essex'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=SUM822'
              f.available_units.should   == 2
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1.5
              f.min_square_feet.should   == 924
              f.max_square_feet.should   == 924
              f.min_rent.should          == 1510.0000
              f.max_rent.should          == 1520.0000
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == 'ESSEX'
              f.external_cms_type.should == 'carmel'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == 'Windsor'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=SUM822'
              f.available_units.should   == 1
              f.bedrooms.should          == 2
              f.bathrooms.should         == 2.5
              f.min_square_feet.should   == 1331
              f.max_square_feet.should   == 1331
              f.min_rent.should          == 2075.0000
              f.max_rent.should          == 2075.0000
              f.floor_plan_group.should  == 'two_bedrooms'
              f.external_cms_id.should   == 'WINDS'
              f.external_cms_type.should == 'carmel'
            end

            c.floor_plans[2].tap do |f|
              f.name.should              == 'Oxford'
              f.availability_url.should  == 'https://onlinelease.carmelapartments.com/welcome.html?community=SUM822'
              f.available_units.should   == 1
              f.bedrooms.should          == 3
              f.bathrooms.should         == 2.5
              f.min_square_feet.should   == 1441
              f.max_square_feet.should   == 1441
              f.min_rent.should          == 2080.0000
              f.max_rent.should          == 2080.0000
              f.floor_plan_group.should  == 'three_bedrooms'
              f.external_cms_id.should   == 'OXFOR'
              f.external_cms_type.should == 'carmel'
            end
          end
        end
      end
    end
  end
end
