module Typus
  module TableHelperExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :typus_table_position_field, :nested_set
      end
    end

    def typus_table_position_field_with_nested_set(attribute, item)
      unless @resource[:class].respond_to?(:acts_as_nested_set_options)
        return typus_table_position_field_without_nested_set(attribute, item)
      end

      html_position = []

      [['Up', 'move_left'], ['Down', 'move_right']].each do |position|
        options = {
          :controller => item.class.name.tableize,
          :action     => 'position',
          :id         => item.id,
          :go         => position.last
        }

        first_or_last = (position.last == 'move_left' && item.left_sibling.nil?) || (position.last == 'move_right' && item.right_sibling.nil?)

        html_position << link_to_unless(first_or_last, _(position.first), params.merge(options)) do |name|
          %(<span class="inactive">#{name}</span>)
        end
      end

      content = html_position.join(' / ').html_safe
      return content_tag(:td, content)
    end
  end
end
