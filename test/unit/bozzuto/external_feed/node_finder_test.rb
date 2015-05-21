require 'test_helper'

module Bozzuto::ExternalFeed
  class NodeFinderTest < ActiveSupport::TestCase
    context "A NodeFinder" do
      before do
        @feed = Bozzuto::ExternalFeed::RentCafeFeed.new(Rails.root.join('test/files/rent_cafe.xml'))
        @xml  = mock('Nokogiri::XML::Document')
        @node = mock('Nokogiri::XML::Element')

        Nokogiri::XML.stubs(:parse).returns(@xml)

        @feed.stubs(:collect)
        @xml.stubs(:remove_namespaces!).returns(@xml)
        @xml.stubs(:children).returns([@node])
      end

      subject do
        Bozzuto::ExternalFeed::NodeFinder.new(@feed)
      end

      describe "#parse" do
        it "finds all property nodes and converts them into Nokogiri::XML documents without namespaces" do
          @xml.expects(:remove_namespaces!).returns(@xml).times(2)

          subject.parse
        end

        it "calls back to the feed each time a complete property node is found" do
          @feed.expects(:collect).with(@node).times(2)

          subject.parse
        end

        context "when there's invalid UTF-8 byte sequences in the given feed file" do
          before do
            @invalid = "<Property>Boom\xA0Town</Property>".force_encoding('UTF-8')
            ::File.stubs(:open).returns([@invalid])
          end
          
          it "catches the error and resolves encoding issues" do
            subject.string.expects(:<<)

            subject.parse
          end
        end
      end
    end
  end
end
