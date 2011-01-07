module AdminHelper
  def render_item_table_field(field, attr_type, item)
    case attr_type
    when :boolean then
      content_tag(:td, _(item.class.typus_boolean(field)["#{item.send(field)}".to_sym]))
    when :datetime then          typus_table_datetime_field(field, item, {})
    when :date then              typus_table_datetime_field(field, item, {})
    when :file then              typus_table_file_field(field, item, {})
    when :time then              typus_table_datetime_field(field, item, {})
    when :belongs_to then        typus_table_belongs_to_field(field, item)
    when :tree then              typus_table_tree_field(field, item)
    when :position then          typus_table_string_field(field, item, {})
    when :selector then          typus_table_selector(field, item)
    when :has_and_belongs_to_many then
      typus_table_has_and_belongs_to_many_field(field, item)
    else
      typus_table_string_field(field, item, {})
    end
  end
  
  def recover_controller
    @resource[:class].ancestors.include?(Property) ? 
      'admin/properties' :
      params[:controller]
  end
  
  def recover_model
    @resource[:class].ancestors.include?(Property) ?
      Property :
      @resource[:class]
  end
  
  def recover_confirm
    if @resource[:self] == 'pages'
      "Recover entry?\nRemember, none of the heirchy associated with this page will be restored."
    else
      "Recover entry?"
    end
  end
end
