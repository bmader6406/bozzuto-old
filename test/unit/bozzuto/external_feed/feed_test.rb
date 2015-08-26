require 'test_helper'

module Bozzuto::ExternalFeed
  class FeedTest < ActiveSupport::TestCase
    context "An External Feed" do
      def described_class
        Bozzuto::ExternalFeed::Feed
      end

      subject { Bozzuto::ExternalFeed::Feed.new(nil) }

      describe ".feed_for_type" do
        subject { Bozzuto::ExternalFeed::Feed }

        context "vaultware" do
          it "returns instance of the correct class" do
            subject.feed_for_type(:vaultware).class.should == Bozzuto::ExternalFeed::VaultwareFeed
          end
        end

        context "rent_cafe" do
          it "returns instance of the correct class" do
            subject.feed_for_type(:rent_cafe).class.should == Bozzuto::ExternalFeed::RentCafeFeed
          end
        end

        context "property_link" do
          it "returns instance of the correct class" do
            subject.feed_for_type(:property_link).class.should == Bozzuto::ExternalFeed::PropertyLinkFeed
          end
        end

        context "psi" do
          it "returns instance of the correct class" do
            subject.feed_for_type(:psi).class.should == Bozzuto::ExternalFeed::PsiFeed
          end
        end

        context "carmel" do
          it "returns instance of the correct class" do
            subject.feed_for_type(:carmel).class.should == Bozzuto::ExternalFeed::CarmelFeed
          end
        end

        context "anything else" do
          it "raises an exception" do
            expect {
              subject.feed_for_type(:blaugh)
            }.to raise_error(NameError)
          end
        end
      end

      describe "#process" do
        context "when the file doesn't exist" do
          it "raises an exception" do
            expect {
              subject.process
            }.to raise_error(Bozzuto::ExternalFeed::Feed::FeedNotFound)
          end
        end

        context "when the file exists" do
          subject { Bozzuto::ExternalFeed::Feed.new(Rails.root.join('test/files/rent_cafe.xml')) }

          before do
            @finder = mock('NodeFinder')
            @finder.stubs(:parse)

            NodeFinder.stubs(:new).with(subject).returns(@finder)
          end

          it "has the NodeFinder parse the feed file" do
            @finder.expects(:parse)

            subject.process
          end

          it "sets the flag for export inclusion to false for all properties" do
            mock('ApartmentCommunity scope').tap do |scope|
              ApartmentCommunity.expects(:included_in_export).returns(scope)

              scope.expects(:update_all).with(:external_cms_type => subject.feed_type, :included_in_export => false)

              subject.process
            end
          end

          it "sets the flag for export inclusion to false for all Property Link units" do
            mock('ApartmentUnit scope').tap do |scope|
              ::ApartmentUnit.expects(:where).with(:external_cms_type => 'property_link').returns(scope)

              scope.expects(:update_all).with(:include_in_export => false)

              subject.process
            end
          end
        end
      end

      describe "#collect" do
        before do
          @data     = mock('Bozzuto::ExternalFeed::Property')
          @importer = mock('Bozzuto::ExternalFeed::PropertyImporter')

          @data.stubs(:title).returns('Title')
          subject.stubs(:build_property).returns(@data)
        end

        it "has the PropertyImporter import the property with the built property data and current feed type" do
          PropertyImporter.stubs(:new).with(@data, subject.feed_type).returns(@importer)

          @importer.expects(:import)

          subject.collect(:property_node)
        end
      end

      describe "#build_property" do
        it "raises an error" do
          expect {
            subject.send(:build_property, nil)
          }.to raise_error(NotImplementedError)
        end
      end

      describe "#build_floor_plan" do
        it "raises an error" do
          expect {
            subject.send(:build_floor_plan, nil, nil)
          }.to raise_error(NotImplementedError)
        end
      end

      describe "#build_apartment_unit" do
        it "raises an error" do
          expect {
            subject.send(:build_apartment_unit, nil, nil)
          }.to raise_error(NotImplementedError)
        end
      end

      describe "#build_apartment_unit_amenity" do
        it "raises an error" do
          expect {
            subject.send(:build_apartment_unit_amenity, nil)
          }.to raise_error(NotImplementedError)
        end
      end

      describe "#floor_plan_group" do
        context "comment matches 'penthouse'" do
          it "returns :penthouse" do
            subject.send(:floor_plan_group, 1, 'PENTHOUSE!').should == 'penthouse'
          end
        end

        context "bedrooms is 0" do
          it "returns :studio" do
            subject.send(:floor_plan_group, 0, nil).should == 'studio'
          end
        end

        context "bedrooms is 1" do
          it "returns :one_bedroom" do
            subject.send(:floor_plan_group, 1, nil).should == 'one_bedroom'
          end
        end

        context "bedrooms is 2" do
          it "returns :two_bedrooms" do
            subject.send(:floor_plan_group, 2, nil).should == 'two_bedrooms'
          end
        end

        context "bedrooms is 3" do
          it "returns :three_bedrooms" do
            subject.send(:floor_plan_group, 3, nil).should == 'three_bedrooms'
          end
        end
      end

      describe "#floor_plan_image_url" do
        before do
          @xml = Nokogiri::XML(<<-XML)
            <Plans>
              <Plan Id="1" />

              <Plan Id="2">
                <File>
                  <Src>file2</Src>
                </File>
              </Plan>

              <Plan Id="3">
                <File>
                  <Src>blah</Src>
                </File>
                <File>
                  <Src>file3</Src>
                  <Rank>1</Rank>
                </File>
              </Plan>
            </Plans>
          XML
        end

        context "File node isn't present" do
          it "returns nil" do
            subject.send(:floor_plan_image_url, nil, @xml.xpath('Plans/Plan[@Id=1]')).should == nil
          end
        end

        context "File node with Rank=1 isn't present" do
          it "returns the Src" do
            subject.send(:floor_plan_image_url, nil, @xml.xpath('Plans/Plan[@Id=2]')).should == 'file2'
          end
        end

        context "File node present" do
          it "returns the Src" do
            subject.send(:floor_plan_image_url, nil, @xml.xpath('Plans/Plan[@Id=3]')).should == 'file3'
          end
        end
      end

      describe "xml helpers" do
        before do
          @xml = Nokogiri::XML(<<-XML)
            <content>
              <text yay="hooray!">yay!</text>
              <data>123</data>
              <data_with_padding>  123  </data>
            </content>
          XML
        end

        describe "#value_at" do
          context "node exists" do
            it "returns the content" do
              subject.send(:value_at, @xml, 'content/text').should == 'yay!'
            end
          end

          context "attribute is present" do
            it "returns the attribute" do
              subject.send(:value_at, @xml, 'content/text', 'yay').should == 'hooray!'
            end
          end

          context "node doesn't exist" do
            it "returns nil" do
              subject.send(:value_at, @xml, 'batman').should == nil
            end
          end
        end

        describe "#string_at" do
          context "node exists" do
            it "returns the content as a string" do
              subject.send(:string_at, @xml, 'content/data').should == '123'
            end
          end

          context "content has padding" do
            it "returns the stripped content" do
              subject.send(:string_at, @xml, 'content/data_with_padding').should == '123'
            end
          end

          context "node doesn't exist" do
            it "returns an empty string" do
              subject.send(:string_at, @xml, 'batman').should == ''
            end
          end
        end

        describe "#int_at" do
          context "node exists" do
            it "returns the content as an int" do
              subject.send(:int_at, @xml, 'content/data').should == 123
            end
          end

          context "node doesn't exist" do
            it "returns 0" do
              subject.send(:int_at, @xml, 'batman').should == 0
            end
          end
        end

        describe "#float_at" do
          context "node exists" do
            it "returns the content as a float" do
              subject.send(:float_at, @xml, 'content/data').should == 123.0
            end
          end

          context "node doesn't exist" do
            it "returns 0.0" do
              subject.send(:float_at, @xml, 'batman').should == 0.0
            end
          end
        end

        describe "#date_for" do
          before do
            @xml = Nokogiri::XML(<<-XML)
              <Unit BuildingId="0" FloorPlanId="250870">
                <Identification IDType="UnitID" IDScopeType="sender" IDRank="primary">
                  <IDValue>3438936</IDValue>
                </Identification>
                <Availability>
                  <VacateDate Month="01" Day="09" Year="2015"/>
                </Availability>
              </ILS_Unit>
            XML
          end

          context "given a node with Year, Month, and Day attributes" do
            it "returns a date object" do
              subject.send(:date_for, @xml.at('Unit/Availability/VacateDate')).should == Date.new(2015, 1, 9)
            end
          end

          context "given a node that does not have the necessary attributes" do
            it "returns nil" do
              subject.send(:date_for, @xml.at('Unit/Identification')).should == nil
            end
          end
        end
      end
    end
  end
end
