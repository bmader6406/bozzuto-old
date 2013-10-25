module Bozzuto
  class RssFetcher
    include HTTParty

    class RssParser < HTTParty::Parser
      SupportedFormats = {
        'application/rss+xml' => :xml,
        'text/xml'            => :xml
      }
    end

    parser RssParser

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def response
      @response ||= fetch
    end

    def parsed_response
      response.parsed_response
    rescue MultiXml::ParseError
      nil
    end

    def feed_valid?
      parsed_response.is_a?(Hash) && parsed_response['rss'].present?
    end

    def found?
      response.code == 200
    end

    def items
      @items ||= begin
        items = parsed_response.try(:[], 'rss').try(:[], 'channel').try(:[], 'item')

        [items].reject(&:nil?).flatten
      end
    end


    private

    def fetch
      self.class.get(url)
    end
  end
end
