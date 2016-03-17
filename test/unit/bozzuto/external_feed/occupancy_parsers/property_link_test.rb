require 'test_helper'

module Bozzuto::ExternalFeed::OccupancyParsers
  class PropertyLinkTest < ActiveSupport::TestCase
    context "A PropertyLink occupancy parser" do
      context "given an occupied status" do
        before do
          @xml = Nokogiri::XML.parse(
            <<-XML
              <ILS_Unit>
                <Unit>
                  <Information>
                    <UnitLeasedStatus>Occupied</UnitLeasedStatus>
                  </Information>
                </Unit>
                <Availability>
                  <MadeReadyDate Month="01" Day="09" Year="2015"/>
                </Availability>
              </ILS_Unit>
            XML
          ).at('ILS_Unit')
        end

        subject { Bozzuto::ExternalFeed::OccupancyParsers::PropertyLink.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Occupied'
        end

        it "returns the correct vacate date" do
          subject.vacate_date.should == Date.new(2015, 1, 9)
        end
      end

      context "given an unoccupied status" do
        before do
          @xml = Nokogiri::XML.parse(
            <<-XML
              <ILS_Unit>
                <Unit>
                  <Information>
                    <UnitLeasedStatus>on notice</UnitLeasedStatus>
                  </Information>
                </Unit>
                <Availability>
                  <MadeReadyDate Month="01" Day="09" Year="2015"/>
                </Availability>
              </ILS_Unit>
            XML
          ).at('ILS_Unit')
        end

        subject { Bozzuto::ExternalFeed::OccupancyParsers::PropertyLink.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Unoccupied'
        end

        it "returns the correct vacate date" do
          subject.vacate_date.should == Date.new(2015, 1, 9)
        end
      end
    end
  end
end
