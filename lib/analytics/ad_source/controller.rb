module Analytics
  module AdSource
    module Controller
      def self.included(base)
        base.class_eval do
          helper_method :dnr_value, :lead_channel_value
        end
      end

      def dnr_value
        request.env['bozzuto.ad_source.dnr']
      end

      def lead_channel_value
        request.env['bozzuto.ad_source.lead_channel']
      end
    end
  end
end
