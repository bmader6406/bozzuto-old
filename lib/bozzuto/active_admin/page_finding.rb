module Bozzuto
  module ActiveAdmin
    module PageFinding
      extend ActiveSupport::Concern

      included do
        around_action :find_pages_by_id
      end

      private

      # Use ID instead of slug in the admin for pages.
      # Routing/paths around pages is really rough.
      # This is the cleanest reliable workaround I've come across.
      def find_pages_by_id
        begin
          Page.class_eval do
            alias :original_to_param :to_param

            def to_param
              id.to_s
            end
          end

          yield
        ensure
          Page.class_eval do
            alias :to_param :original_to_param
          end
        end
      end
    end
  end
end
