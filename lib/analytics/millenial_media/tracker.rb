module Analytics
  module MillenialMedia
    class Tracker
      TRACKING_ID = 26148

      BASE_URL = "http://cvt.mydas.mobi/handleConversion"

      attr_reader :mmurid

      def self.track_with_mmurid(mmurid)
        new(mmurid).track
      end

      def initialize(mmurid)
        @mmurid = mmurid
      end

      def track
        url = tracking_url

        log("Track: #{url}")
        HTTParty.get(url)
      end

      def logger
        Rails.logger
      end

      def log(message)
        logger.info "==> [Millenial Media] #{message}"
      end


      private

      def tracking_url
        url    = BASE_URL
        params = ["goalid=#{TRACKING_ID}", "urid=#{mmurid}"].join('&')

        [url, params].join('?')
      end
    end
  end
end
