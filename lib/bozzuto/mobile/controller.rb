module Bozzuto
  module Mobile
    module Controller
      def self.included(base)
        base.class_eval do
          class_attribute :mobile_actions
          self.mobile_actions = []

          def self.has_mobile_actions(*actions)
            self.mobile_actions = actions.map(&:to_sym)
          end

          helper_method :device, :mobile?, :mobile_device?

          before_filter :require_mobile_action
        end
      end

      def device
        request.env['bozzuto.mobile.device']
      end

      def mobile?
        request.format.to_sym == :mobile
      end

      def mobile_device?
        device != :browser
      end

      def has_mobile_action?(action)
        self.class.mobile_actions.include?(action.to_sym)
      end

      def require_mobile_action
        if mobile? && !has_mobile_action?(params[:action].to_sym)
          redirect_to root_path
        end
      end
    end
  end
end
