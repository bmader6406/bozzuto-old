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
        @xml.stubs(:at).with('./Property').returns(@node)
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
      end
    end
  end
end
