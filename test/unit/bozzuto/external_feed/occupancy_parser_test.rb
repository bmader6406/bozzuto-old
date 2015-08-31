require 'test_helper'

module Bozzuto::ExternalFeed
  class OccupancyParserTest < ActiveSupport::TestCase
    context "An OccupancyParser" do
      context "for a standard feed type (Vaultware/PSI)" do
        context "given an occupied status" do
          before do
            @xml = Nokogiri::XML.parse <<-XML
              <Availability>
                <VacancyClass>Occupied</VacancyClass>
              </Availability>
            XML
          end

          subject { OccupancyParser.for(:psi).new(@xml) }

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

            subject { OccupancyParser.for(:psi).new(@xml) }

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

          subject { OccupancyParser.for(:vaultware).new(@xml) }

          it "returns the correct vacancy class" do
            subject.vacancy_class.should == 'Unoccupied'
          end

          it "returns the correct vacate date" do
            subject.vacate_date.should == Date.new(2015, 1, 9)
          end
        end
      end

      context "for Rent Cafe" do
        context "given an occupied status" do
          before do
            @xml = Nokogiri::XML.parse <<-XML
              <UnitLeasedStatusDescription>Notice Unrented</UnitLeasedStatusDescription>
            XML
          end

          subject { OccupancyParser.for(:rent_cafe).new(@xml) }

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
                    <DateAvailable Month="01" Day="09" Year="2015"/>
                  </ILS_Unit>
                XML
              ).at('./ILS_Unit')
            end

            subject { OccupancyParser.for(:rent_cafe).new(@xml) }

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

          subject { OccupancyParser.for(:rent_cafe).new(@xml) }

          it "returns the correct vacancy class" do
            subject.vacancy_class.should == 'Unoccupied'
          end

          it "returns the correct vacate date" do
            subject.vacate_date.should == nil
          end
        end
      end

      context "for Property Link" do
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

          subject { OccupancyParser.for(:property_link).new(@xml) }

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

          subject { OccupancyParser.for(:property_link).new(@xml) }

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
end
