require 'net/ftp'

module Bozzuto
  module ExternalFeed
    class OutboundFtp
      include Ftp

      SERVER = 'bozzutofeed.qburst.com'

      def self.transfer(file)
        new.transfer(file)
      end

      def transfer(file)
        raise ArgumentError, 'The given file name does not exist.' unless File.exists?(file)

        connect_to SERVER do |ftp|
          ftp.putbinaryfile(file)
        end
      end
    end
  end
end
