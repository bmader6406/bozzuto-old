require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class Ftp
      class_attribute :username, :password

      def self.download_files
        new.download_files
      end

      def download_files
        Net::FTP.open('feeds.livebozzuto.com') do |ftp|
          ftp.passive = true
          ftp.login(username, password)

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
