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
        %w(carmel)
      end

      private

      def server
        'bozzutofeed.qburst.com'
      end

      def source_file_for(feed_type)
        (feed_type.gsub('_', '') + '.xml').capitalize
      end
    end
  end
end
