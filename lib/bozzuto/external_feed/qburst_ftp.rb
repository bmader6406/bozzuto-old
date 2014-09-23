require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class QburstFtp
      include Ftp

      private

      def server
        'bozzutofeed.qburst.com'
      end

      def feed_types
        %w(carmel)
      end

      def source_file_for(feed_type)
        (feed_type.gsub('_', '') + '.xml').capitalize
      end
    end
  end
end
