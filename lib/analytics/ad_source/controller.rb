module Analytics
  module AdSource
    module Controller
      def self.included(base)
        base.class_eval do
          helper_method :dnr_ad_source, :lead_channel
        end
      end

      def dnr_ad_source
        request.env['bozzuto.ad_source.dnr']
      end

      def lead_channel
        request.env['bozzuto.ad_source.lead_channel']
      end
    end
  end
end
