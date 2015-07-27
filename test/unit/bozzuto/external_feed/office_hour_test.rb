require 'test_helper'

module Bozzuto::ExternalFeed
  class OfficeHourTest < ActiveSupport::TestCase
    context "OfficeHour" do
      context "given standard formatting" do
        subject do
          Bozzuto::ExternalFeed::OfficeHour.new(
            :day       => 'Sunday',
            :opens_at  => '12:00 PM',
            :closes_at => '5:00 PM'
          )
        end

        describe "#database_attributes" do
          it "returns valid attributes for an OfficeHour record" do
            subject.database_attributes.should == {
              :day              => 0,
              :closed           => false,
              :opens_at         => '12:00',
              :opens_at_period  => 'PM',
              :closes_at        => '5:00',
              :closes_at_period => 'PM'
            }
          end
        end
      end

      context "given non-standard formatting" do
        subject do
          Bozzuto::ExternalFeed::OfficeHour.new(
            :day       => 'Su',
            :opens_at  => '10:30:00 AM',
            :closes_at => '07:00:00 PM'
          )
        end

        describe "#database_attributes" do
          it "returns valid attributes for an OfficeHour record" do
            subject.database_attributes.should == {
              :day              => 0,
              :closed           => false,
              :opens_at         => '10:30',
              :opens_at_period  => 'AM',
              :closes_at        => '7:00',
              :closes_at_period => 'PM'
            }
          end
        end
      end

      context "given a closed value" do
        subject do
          Bozzuto::ExternalFeed::OfficeHour.new(
            :day       => 'Mon',
            :opens_at  => nil,
            :closes_at => 'CLOSED'
          )
        end

        describe "#database_attributes" do
          it "returns valid attributes for an OfficeHour record" do
            subject.database_attributes.should == {
              :day              => 1,
              :closed           => true,
              :opens_at         => nil,
              :opens_at_period  => nil,
              :closes_at        => nil,
              :closes_at_period => nil
            }
          end
        end
      end
    end
  end
end
