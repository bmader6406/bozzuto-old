module Analytics
  module DnrAndLeadChannel
    module Controller
      def self.included(base)
        base.class_eval do
          helper_method :dnr_value, :lead_channel_value
        end
      end

      def dnr_value
        request.env['bozzuto.dnr']
      end

      def lead_channel_value
        request.env['bozzuto.lead_channel']
      end
    end
  end
end
