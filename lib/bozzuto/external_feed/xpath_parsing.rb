require 'addressable'

module Bozzuto
  module ExternalFeed
    module XpathParsing
      HTTPS_NOT_SUPPORTED = %w(
        media.propertylinkonline.com
        static.propertylinkonline.com
      )
      DOUBLE_ESCAPED_EXPR = /%25([0-9a-f]{2})/i

      def value_at(node, xpath, attribute = nil)
        if attribute
          node.at(xpath).try(:[], attribute)
        else
          node.at(xpath).try(:content)
        end
      end

      def string_at(node, xpath, attribute = nil)
        value_at(node, xpath, attribute).to_s.strip
      end

      def int_at(node, xpath, attribute = nil)
        value_at(node, xpath, attribute).to_i
      end

      def float_at(node, xpath, attribute = nil)
        value_at(node, xpath, attribute).to_f
      end

      def url_at(node, xpath, attribute = nil)
        url_string = value_at(node, xpath, attribute)
        url = encode_url(url_string)
        uri = URI(url)
        uri.scheme = 'https' if HTTPS_NOT_SUPPORTED.exclude?(uri.host)
        uri.to_s
      end

      def encode_url(url_string)
        url = Addressable::URI.encode(url_string).gsub(DOUBLE_ESCAPED_EXPR, '%\1')
      end

      def date_for(node)
        return if node.nil? || node['Year'].nil? || node['Month'].nil? || node['Day'].nil?
        begin
          Date.new(node['Year'].to_i, node['Month'].to_i, node['Day'].to_i)
        rescue => e
          puts "invalid date"
          return
        end
      end
    end
  end
end
