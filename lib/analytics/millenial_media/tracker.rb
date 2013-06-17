module Analytics
  module MillenialMedia
    class Tracker
      TRACKING_ID = 26148

      BASE_URL = "http://cvt.mydas.mobi/handleConversion"

      attr_reader :urid

      def self.track_with_urid(urid)
        new(urid).track
      end

      def initialize(urid)
        @urid = urid
      end

      def track
        HTTParty.get(tracking_url)
      end

      private

      def tracking_url
        url    = BASE_URL
        params = ["goalid=#{TRACKING_ID}", "urid=#{urid}"].join('&')

        [url, params].join('?')
      end
    end
  end
end
