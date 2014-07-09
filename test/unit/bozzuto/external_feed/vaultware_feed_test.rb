require 'test_helper'

module Bozzuto::ExternalFeed
  class VaultwareFeedTest < ActiveSupport::TestCase
    context "A VaultwareFeed" do
      subject { Bozzuto::ExternalFeed::VaultwareFeed.new(Rails.root.join('test/files/vaultware.xml')) }

      describe "#feed_name" do
        it "returns 'Vaultware'" do
          subject.feed_name.should == 'Vaultware'
        end
      end

      describe "#properties" do
        it "returns the correct properties" do
          subject.properties.count.should == 2

          subject.properties[0].tap do |c|
            c.title.should             == 'Hunters Glen'
            c.street_address.should    == '14210 Slidell Court'
            c.city.should              == 'Upper Marlboro'
            c.state.should             == 'MD'
            c.availability_url.should  == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=14317'
            c.external_cms_id.should   == '14317'
            c.external_cms_type.should == 'vaultware'
            c.office_hours.should      == [
              { :open_time => "09:00 AM", :day => "Monday",    :close_time => "06:00 PM" },
              { :open_time => "09:00 AM", :day => "Tuesday",   :close_time => "06:00 PM" },
              { :open_time => "09:00 AM", :day => "Wednesday", :close_time => "06:00 PM" },
              { :open_time => "09:00 AM", :day => "Thursday",  :close_time => "06:00 PM" },
              { :open_time => "08:00 AM", :day => "Friday",    :close_time => "05:00 PM" },
              { :open_time => "10:00 AM", :day => "Saturday",  :close_time => "05:00 PM" },
              { :open_time => "12:00 PM", :day => "Sunday",    :close_time => "05:00 PM" }
            ]

            c.floor_plans.count.should == 2

            c.floor_plans[0].tap do |f|
              f.name.should              == '1 Bedroom 1 Bath'
              f.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=9797'
              f.available_units.should   == 3
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 780
              f.max_square_feet.should   == 780
              f.min_rent.should          == 1480
              f.max_rent.should          == 1505
              f.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/27983'
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '9797'
              f.external_cms_type.should == 'vaultware'
            end

            c.floor_plans[1].tap do |f|
              f.name.should              == '1 Bedroom W/Den, 1 Bath'
              f.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=9798'
              f.available_units.should   == 1
              f.bedrooms.should          == 1
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 881
              f.max_square_feet.should   == 881
              f.min_rent.should          == 1585
              f.max_rent.should          == 1585
              f.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/27989'
              f.floor_plan_group.should  == 'one_bedroom'
              f.external_cms_id.should   == '9798'
              f.external_cms_type.should == 'vaultware'
            end
          end

          subject.properties[1].tap do |c|
            c.title.should             == 'The Courts of Devon'
            c.street_address.should    == '501 Main Street'
            c.city.should              == 'Gaithersburg'
            c.state.should             == 'MD'
            c.availability_url.should  == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=16976'
            c.external_cms_id.should   == '16976'
            c.external_cms_type.should == 'vaultware'
            c.office_hours.should      == [
              { :open_time => "09:00 AM", :day => "Monday",    :close_time => "06:00 PM" },
              { :open_time => "08:00 AM", :day => "Tuesday",   :close_time => "06:00 PM" },
              { :open_time => "08:00 AM", :day => "Wednesday", :close_time => "06:00 PM" },
              { :open_time => "09:00 AM", :day => "Thursday",  :close_time => "06:00 PM" },
              { :open_time => "08:00 AM", :day => "Friday",    :close_time => "05:00 PM" },
              { :open_time => "10:00 AM", :day => "Saturday",  :close_time => "05:00 PM" },
              { :open_time => "12:00 PM", :day => "Sunday",    :close_time => "05:00 PM" }
            ]

            c.floor_plans.count.should == 1

            c.floor_plans[0].tap do |f|
              f.name.should              == '2 Bedroom/1 Bath'
              f.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=20294'
              f.available_units.should   == 5
              f.bedrooms.should          == 2
              f.bathrooms.should         == 1
              f.min_square_feet.should   == 761
              f.max_square_feet.should   == 833
              f.min_rent.should          == 1540
              f.max_rent.should          == 1820
              f.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/62315'
              f.floor_plan_group.should  == 'two_bedrooms'
              f.external_cms_id.should   == '20294'
              f.external_cms_type.should == 'vaultware'
            end
          end
        end
      end
    end
  end
end
