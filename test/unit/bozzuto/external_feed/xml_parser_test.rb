require 'test_helper'

module Bozzuto::ExternalFeed
  class XmlParserTest < ActiveSupport::TestCase
    context "A XmlParser" do
      before do
        @file     = ::File.open(Rails.root.join('test/files/rent_cafe.xml'))
        @importer = mock('Bozzuto::ExternalFeed::Importer')

        @xml  = mock('Nokogiri::XML::Document')
        @node = mock('Nokogiri::XML::Element')

        Nokogiri::XML.stubs(:parse).returns(@xml)

        @importer.stubs(:file).returns(@file)
        @importer.stubs(:collect)

        @xml.stubs(:remove_namespaces!).returns(@xml)
        @xml.stubs(:at).with('./Property').returns(@node)
      end

      subject do
        Bozzuto::ExternalFeed::XmlParser.new(@importer)
      end

      describe "#parse" do
        it "finds all property nodes and converts them into Nokogiri::XML documents without namespaces" do
          @xml.expects(:remove_namespaces!).returns(@xml).times(2)

          subject.parse
        end

        it "calls back to the importer each time a complete property node is found" do
          @importer.expects(:collect).with(@node).times(2)

          subject.parse
        end
      end
    end
  end
end