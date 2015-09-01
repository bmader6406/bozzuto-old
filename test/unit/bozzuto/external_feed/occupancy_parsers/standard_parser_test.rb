require 'test_helper'

module Bozzuto::ExternalFeed::OccupancyParsers
  class StandardParserTest < ActiveSupport::TestCase
    context "A standard occupancy parser" do
      context "given an occupied status" do
        before do
          @xml = Nokogiri::XML.parse <<-XML
            <Availability>
              <VacancyClass>Occupied</VacancyClass>
            </Availability>
          XML
        end

        subject { StandardParser.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Occupied'
        end

        it "returns the correct vacate date" do
          subject.vacate_date.should == nil
        end

        context "with a vacate date" do
          before do
            @xml = Nokogiri::XML.parse <<-XML
              <Availability>
                <VacateDate Month="01" Day="09" Year="2015"/>
                <VacancyClass>Occupied</VacancyClass>
              </Availability>
            XML
          end

          subject { StandardParser.new(@xml) }

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
            <Availability>
              <VacateDate Month="01" Day="09" Year="2015"/>
              <VacancyClass>Unoccupied</VacancyClass>
            </Availability>
          XML
        end

        subject { StandardParser.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Unoccupied'
        end

        it "returns the correct vacate date" do
          subject.vacate_date.should == Date.new(2015, 1, 9)
        end
      end

      context "when there is no occupancy data" do
        before do
          @xml = Nokogiri::XML.parse <<-XML
            <Availability></Availability>
          XML
        end

        subject { StandardParser.new(@xml) }

        it "returns the correct vacancy class" do
          subject.vacancy_class.should == 'Occupied'
        end
      end
    end
  end
end
