module Analytics
  module AdSource
    module Controller
      def self.included(base)
        base.class_eval do
          helper_method :ad_source, :dnr_ad_source, :lead_channel
        end
      end

      def ad_source
        request.env['bozzuto.ad_source']
      end

      alias :dnr_ad_source :ad_source
      alias :lead_channel  :ad_source
    end
  end
end
