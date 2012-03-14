module Typus
  module SidebarHelperExtensions
    def self.included(base)
      base.class_eval do
        def search
          typus_search = @resource[:class].typus_defaults_for(:search)
          return if typus_search.empty?

          search_by = typus_search.map { |attr|
            attr.gsub(/^\w+\./, '')
          }.map { |attr|
            @resource[:class].human_attribute_name(attr)
          }.to_sentence

          search_params = params.dup
          %w( action controller search page id ).each { |p| search_params.delete(p) }

          hidden_params = search_params.map { |k, v| hidden_field_tag(k, v) }

          render "admin/helpers/search", 
                 :hidden_params => hidden_params, 
                 :search_by => search_by
        end
      end
    end
  end
end
