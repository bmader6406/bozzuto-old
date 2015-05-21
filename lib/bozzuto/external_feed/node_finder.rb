module Bozzuto::ExternalFeed
  class NodeFinder
    OPEN  = /<Property(\s+\w+=\S+)*>/
    CLOSE = /<\/Property>/

    attr_accessor :feed, :in_property_node, :string

    def initialize(feed)
      @feed             = feed
      @in_property_node = false
      @string           = ''
    end

    def parse
      ::File.open(feed.file).each do |line|
        process(line)

        feed.collect(property_node) if complete_node_found?
      end
    end

    private

    def process(line)
      entering_node if line.match OPEN

      string << line if in_property_node

      exiting_node if line.match CLOSE
    rescue ArgumentError
      line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ' ')
      retry
    end

    def entering_node
      self.in_property_node = true
    end

    def exiting_node
      self.in_property_node = false
    end

    def complete_node_found?
      !string.empty? && !in_property_node
    end

    def property_node
      xml_document.children.first.tap { reset! }
    end

    def xml_document
      Nokogiri::XML.parse(string).remove_namespaces!
    end

    def reset!
      string.clear
    end
  end
end
