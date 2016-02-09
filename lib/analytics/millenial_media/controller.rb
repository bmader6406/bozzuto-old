module Analytics
  module MillenialMedia
    module Controller

      def track_millenial_media_mmurid
        if session[:mmurid].present?
          ::Analytics::MillenialMedia::Tracker.track_with_mmurid(session[:mmurid])

          session[:mmurid] = nil
        end
      end
    end
  end
end
