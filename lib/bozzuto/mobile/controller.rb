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

          before_filter :detect_full_site_flag
          before_filter :detect_mobile
          before_filter :verify_mobile_format
        end
      end

      private 

      def detect_full_site_flag
        value = request.env['bozzuto.mobile.force_full_site']

        if value.present? && CookiesController::CHECK_IF_ENABLED[cookies]
          session[:force_full_site] = value
        end
      end

      def detect_mobile
        if mobile_request?
          render_mobile_site!
        end
      end

      def verify_mobile_format
        if mobile? && !has_mobile_action?(params[:action])
          render_full_site!
        end
      end

      def device
        request.env['bozzuto.mobile.device'] || :browser
      end

      def mobile?
        request.format.try(:to_sym) == :mobile
      end

      def mobile_device?
        device != :browser
      end

      def render_full_site!
        request.format = :html
      end

      def render_mobile_site!
        request.format = :mobile
      end

      def has_mobile_action?(action)
        self.class.mobile_actions.include?(action.to_sym)
      end

      def force_mobile?
        session[:force_full_site] == "0"
      end

      def force_browser?
        session[:force_full_site] == "1"
      end

      def mobile_request?
        params['format'] == 'mobile' || (device != :browser && !force_browser?) || force_mobile?
      end

      def fragment_cache_key(base_key)
        key    = base_key.is_a?(Hash) ? url_for(base_key).split('://').last : base_key
        prefix = mobile_request? ? 'views-mobile' : 'views'

        ActiveSupport::Cache.expand_cache_key(key, prefix)
      end
    end
  end
end
