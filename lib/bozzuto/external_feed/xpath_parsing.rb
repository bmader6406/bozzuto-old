module Bozzuto
  module ExternalFeed
    module XpathParsing
      HTTPS_NOT_SUPPORTED = %w(
        media.propertylinkonline.com
      )

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
        url = URI.encode value_at(node, xpath, attribute)
        uri = URI(url)
        uri.scheme = 'https' if HTTPS_NOT_SUPPORTED.exclude?(uri.host)
        uri.to_s
      end

      def date_for(node)
        return if node.nil? || node['Year'].nil? || node['Month'].nil? || node['Day'].nil?

        Date.new(node['Year'].to_i, node['Month'].to_i, node['Day'].to_i)
      end
    end
  end
end
