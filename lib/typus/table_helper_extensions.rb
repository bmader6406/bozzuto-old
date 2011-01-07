module Typus
  module TableHelperExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :typus_table_position_field, :nested_set
        alias_method_chain :typus_table_remove_action, :config
      end
    end

    def typus_table_position_field_with_nested_set(attribute, item)
      unless item.class.respond_to?(:acts_as_nested_set_options)
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


    def typus_table_remove_action_with_config(related_model, fields, item, field)
      trash = '<div class="sprite trash">Trash</div>'.html_safe
      model = @resource[:class]
      
      destroy = model.typus_field_options_for(:destroy_related).include?(related_model.to_s.to_sym)

      condition = if related_model.typus_user_id? && @current_user.is_not_root?
        item.owned_by?(@current_user)
      else
        @current_user.can?('destroy', related_model)
      end
      
      if related_model == Page
        confirm_message = "Remove entry?\nDoing so will also Remove all children, and the heirarchy will not be preserved."
        if params[:action] =='edit' && condition && destroy
          link_to trash, { :action => 'destroy', :id => item.id }, 
                                     :title => _("Remove"), 
                                     :confirm => _(confirm_message)
        else
          link_to trash, {
              :controller => related_model.to_s.tableize,
              :action => 'destroy',
              :id => item.id
            },
            :title => _("Remove"),
            :confirm => _(confirm_message) if condition
        end
      else

        if params[:action] =='edit' && condition && destroy
          link_to trash, {
              :controller => related_model.to_s.tableize,
              :action => 'destroy',
              :id => item.id
            },
            :title => _("Remove"),
            :confirm => _("Remove entry?")
        else
          typus_table_remove_action_without_config(related_model, fields, item, field)
        end
      end
    end
  end
end
