module Bozzuto
  module ExternalFeed
    class NodeFinder < Struct.new(:feed)
      def parse
        Nokogiri::XML::Reader(::File.open(feed.file)).each do |node|
          if start_of_property?(node)
            feed.collect Nokogiri::XML.parse(node.outer_xml).remove_namespaces!.at('./Property')
          end
        end
      end

      private

      def start_of_property?(node)
        node.name == 'Property' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
      end
    end
  end
end
