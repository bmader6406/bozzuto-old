require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class InboundFtp
      include Ftp

      SERVER = 'feeds.livebozzuto.com'

      def self.download_files
        new.download_files
      end

      def download_files
        connect_to SERVER do |ftp|
          Feed.feed_types.each do |type|
            ftp.getbinaryfile(source_file_for(type), target_location_for(type))
          end
        end
      end

      private

      def source_file_for(feed_type)
        feed_type.gsub('_', '') + '.xml'
      end

      def target_location_for(feed_type)
        Feed.feed_for_type(feed_type).default_file
      end
    end
  end
end
