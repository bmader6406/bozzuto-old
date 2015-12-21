require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class QburstFtp
      include Ftp
      include LoadingProcess

      allow_loading_every 2.hours
      identify_loading_process_as 'qburst_ftp'

      self.ftp_name = 'Qburst'

      def feed_types
        []
      end

      private

      def server
        'bozzutofeed.qburst.com'
      end
    end
  end
end
