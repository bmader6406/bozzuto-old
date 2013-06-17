module Analytics
  module MillenialMedia
    module Controller
      def self.included(base)
        base.class_eval do
          before_filter :save_urid_param
        end
      end

      def save_urid_param
        if params[:urid].present?
          session[:urid] = params[:urid]
        end
      end

      def track_millenial_media_urid
        if session[:urid].present?
          ::Analytics::MillenialMedia::Tracker.track_with_urid(session[:urid])

          session[:urid] = nil
        end
      end
    end
  end
end
