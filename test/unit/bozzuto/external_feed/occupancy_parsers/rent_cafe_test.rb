require 'test_helper'

module Bozzuto::ExternalFeed::OccupancyParsers
  class RentCafeTest < ActiveSupport::TestCase
    context "A Rent Cafe occupancy parser" do
      context "given an occupied status" do
        before do
          @xml = Nokogiri::XML.parse <<-XML
            <UnitLeasedStatusDescription>Notice Unrented</UnitLeasedStatusDescription>
          XML
        end

        subject { RentCafe.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Occupied'
        end

        it "returns the correct vacate date" do
          subject.vacate_date.should == nil
        end

        context "of 'Notice Unrented' with a vacate date" do
          before do
            @xml = Nokogiri::XML.parse(
              <<-XML
                <ILS_Unit>
                  <UnitLeasedStatusDescription>Notice Unrented</UnitLeasedStatusDescription>
                  <DateAvailable>1/9/2015</DateAvailable>
                </ILS_Unit>
              XML
            ).at('./ILS_Unit')
          end

          subject { RentCafe.new(@xml) }

          it "returns the correct vacancy class" do
            subject.vacancy_class.should == 'Unoccupied'
          end

          it "returns the correct vacate date" do
            subject.vacate_date.should == Date.new(2015, 1, 9)
          end
        end
      end

      context "given an unoccupied status" do
        before do
          @xml = Nokogiri::XML.parse <<-XML
            <UnitLeasedStatusDescription>Vacant Unrented Ready</UnitLeasedStatusDescription>
          XML
        end

        subject { RentCafe.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Unoccupied'
        end

        it "returns the correct vacate date" do
          subject.vacate_date.should == nil
        end
      end
    end
  end
end
