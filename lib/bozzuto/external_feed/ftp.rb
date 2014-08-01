require 'net/ftp'

module Bozzuto
  module ExternalFeed
    module Ftp

      def self.included(base)
        base.class_eval do
          class_attribute :username, :password
        end
      end

      private

      def connect_to(server)
        Net::FTP.open server do |ftp|
          ftp.passive = true
          ftp.login(username, password)

          yield ftp
        end
      end
    end
  end
end
