module Bozzuto
  module Mobile
    MOBILE_USER_AGENTS = {
      /iPhone/          => :iphone,
      /BlackBerry/      => :blackberry,
      /IEMobile/        => :iemobile,
      /webOS/           => :webos,
      /Symbian/         => :symbian,
      /NetFront/        => :netfront,
      /Maemo/           => :maemo,
      /Meego/           => :maemo,
      /Android.*Fennec/ => :android,
      /Android/         => :android,
      /Fennec/          => :fennec
    }

    class UserAgent
      attr_reader :user_agent_string

      def initialize(user_agent_string)
        @user_agent_string = user_agent_string
      end

      def mobile?
        device != :browser
      end

      def device
        @device ||= begin
          key = MOBILE_USER_AGENTS.keys.detect { |user_agent_key|
            user_agent_string.match(user_agent_key).present?
          }

          if key.present?
            MOBILE_USER_AGENTS[key]
          else
            :browser
          end
        end
      end
    end
  end
end
