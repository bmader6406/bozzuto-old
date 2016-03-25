module Bozzuto
  module ActiveAdmin
    module ActionRedirects

      def smart_resource_url
        if returnable?
          return_to = session[:return_to]
          session[:return_to] = nil
          return_to
        else
          super
        end
      end

      private

      def returnable?
        session[:return_to].present? && (action_name == 'create' || action_name == 'update')
      end
    end
  end
end
