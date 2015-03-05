require 'test_helper'

class OfficeHourTest < ActiveSupport::TestCase
  context "OfficeHour" do
    before do
      @office_hour = OfficeHour.make(
        :day       => 1,
        :opens_at  => '8:00',
        :closes_at => '6:00'
      )
    end

    should belong_to(:property)

    should validate_presence_of(:property)
    should validate_presence_of(:day)
    should validate_presence_of(:opens_at)
    should validate_presence_of(:opens_at_period)
    should validate_presence_of(:closes_at)
    should validate_presence_of(:closes_at_period)

    should validate_uniqueness_of(:day).scoped_to(:property_id)

    should ensure_inclusion_of(:day).in_range(0..6)

    OfficeHour::MERIDIAN_INDICATORS.each do |indicator|
      should allow_value(indicator).for(:opens_at_period)
      should allow_value(indicator).for(:closes_at_period)

      should_not allow_value(indicator.first).for(:opens_at_period)
      should_not allow_value(indicator.last).for(:closes_at_period)
    end

    describe "#day_name" do
      it "returns the string representation of the day number" do
        @office_hour.day_name.should == 'Monday'
      end
    end

    describe "#to_s" do
      it "returns a string representation of the office hours" do
        @office_hour.to_s.should == 'Monday: 8:00AM - 6:00PM'
      end
    end
  end
end
