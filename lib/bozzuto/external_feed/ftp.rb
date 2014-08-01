require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class Ftp
      SERVER = 'feeds.livebozzuto.com'

      class_attribute :username, :password

      def self.download_files
        new.download_files
      end

      def self.transfer(file)
        new.transfer(file)
      end

      def download_files
        connect do |ftp|
          Feed.feed_types.each do |type|
            ftp.getbinaryfile(source_file_for(type), target_location_for(type))
          end
        end
      end

      def transfer(file)
        raise ArgumentError, 'The given file name does not exist.' unless File.exists?(file)

        connect { |ftp| ftp.putbinaryfile(file) }
      end

      private

      def connect
        Net::FTP.open SERVER do |ftp|
          ftp.passive = true
          ftp.login(username, password)

          yield ftp
        end
      end

      def source_file_for(feed_type)
        feed_type.gsub('_', '') + '.xml'
      end

      def target_location_for(feed_type)
        Feed.feed_for_type(feed_type).default_file
      end
    end
  end
end
