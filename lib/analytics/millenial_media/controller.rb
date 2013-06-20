module Analytics
  module MillenialMedia
    module Controller
      def self.included(base)
        base.class_eval do
          before_filter :save_mmurid_param
        end
      end

      def save_mmurid_param
        if params[:mmurid].present?
          session[:mmurid] = params[:mmurid]
        end
      end

      def track_millenial_media_mmurid
        if session[:mmurid].present?
          ::Analytics::MillenialMedia::Tracker.track_with_mmurid(session[:mmurid])

          session[:mmurid] = nil
        end
      end
    end
  end
end
