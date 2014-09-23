require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class LiveBozzutoFtp
      include Ftp

      private

      def server
        'feeds.livebozzuto.com'
      end

      def feed_types
        Feed.feed_types - ['carmel']
      end
    end
  end
end
