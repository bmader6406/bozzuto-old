module Bozzuto
  module ExternalFeed
    class XmlParser

      def initialize(importer)
        @importer = importer
      end

      def parse
        nodes.each do |node|
          if start_of_property?(node)
            importer.collect Nokogiri::XML.parse(node.outer_xml).remove_namespaces!.at('./Property')
          end
        end
      end

      private

      attr_reader :importer

      def nodes
        Nokogiri::XML::Reader(file)
      end

      def file
        ::File.open(importer.file.path)
      end

      def start_of_property?(node)
        node.name == 'Property' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
      end
    end
  end
end
