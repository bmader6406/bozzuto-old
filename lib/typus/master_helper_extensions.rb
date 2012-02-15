module Typus
  module MasterHelperExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :build_list, :special_cases
      end
    end
    
    def build_list_with_special_cases(model, fields, items, resource = @resource[:self], link_options = {}, association = nil, field = nil)
      if resource == 'landing_page_popular_orderings'
        fields.delete('position') if !@item.custom_sort_popular_properties?
        items_to_relate = (Property.ordered_by_title - @item.popular_properties)

        render :partial => 'admin/landing_page_popular_orderings/table', :locals => {
          :fields          => fields,
          :items           => items,
          :link_options    => link_options,
          :items_to_relate => items_to_relate
        }
      else
        build_list_without_special_cases(model, fields, items, resource, link_options, association, field)
      end
    end
    
    def render_table_fields(item, fields, link_options)
      String.new.tap do |html|
        fields.each do |key, value|
          html << case value
          when :boolean then    typus_table_boolean_field(key, item)
          when :datetime then   typus_table_datetime_field(key, item, link_options)
          when :date then       typus_table_datetime_field(key, item, link_options)
          when :file then       typus_table_file_field(key, item, link_options)
          when :time then       typus_table_datetime_field(key, item, link_options)
          when :belongs_to then typus_table_belongs_to_field(key, item)
          when :tree then       typus_table_tree_field(key, item)
          when :position then   typus_table_position_field(key, item)
          when :selector then   typus_table_selector(key, item)
          when :has_and_belongs_to_many then
            typus_table_has_and_belongs_to_many_field(key, item)
          else
            typus_table_string_field(key, item, link_options)
          end
        end
      end
    end
    
  end
end
