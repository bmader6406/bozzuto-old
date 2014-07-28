require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class Ftp
      class_attribute :username, :password

      attr_reader :feed_type, :target_location

      def self.download_file_for(feed_type)
        new(feed_type).download_file
      end

      def initialize(feed_type)
        @feed_type       = feed_type
        @target_location = Feed.feed_for_type(feed_type).default_file
      end

      def download_file
        Net::FTP.open('feeds.livebozzuto.com') do |ftp|
          ftp.passive = true
          ftp.login(username, password)
          ftp.getbinaryfile(source_file, target_location)
        end
      end

      private

      def source_file
        feed_type.to_s.gsub('_', '') + '.xml'
      end
    end
  end
end
