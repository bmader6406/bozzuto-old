module Bozzuto
  module Mobile
    def self.included(base)
      base.class_eval do
        def self.browser_only!
          define_method("force_browser?") { true }
        end

        attr_accessor :device
        helper_method :device

        helper_method :mobile?

        before_filter :maintain_force_mobile_session_value
        before_filter :detect_mobile_user_agent
      end
    end

    def maintain_force_mobile_session_value
      if params[:full_site].present?
        session[:force_full_site] = params[:full_site]
      end
    end

    def detect_mobile_user_agent
      ua  = request.env['HTTP_USER_AGENT'] || ''
      key = MOBILE_USER_AGENTS.keys.detect { |user_agent_key|
        ua.match(user_agent_key).present?
      }

      self.device = if key.present?
        MOBILE_USER_AGENTS[key]
      else
        :browser
      end

      if (device != :browser && !force_browser?) || force_mobile?
        request.format = :mobile
      end
    end

    def mobile?
      request.format.to_sym == :mobile
    end

    def force_mobile?
      session[:force_full_site] == "0"
    end

    def force_browser?
      session[:force_full_site] == "1"
    end
  end
end
