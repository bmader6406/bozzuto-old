require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class LiveBozzutoFtp
      include Ftp
      include LoadingProcess

      allow_loading_every 2.hours
      identify_loading_process_as 'live_bozzuto_ftp'

      self.ftp_name = 'Live Bozzuto'

      def feed_types
        Bozzuto::ExternalFeed::SOURCES
      end

      private

      def server
        'feeds.livebozzuto.com'
      end
    end
  end
end
