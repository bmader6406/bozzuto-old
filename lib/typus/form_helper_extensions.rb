module Typus
  module FormHelperExtensions
    def self.included(base)
      base.class_eval do
        def typus_preview(item, attribute)
          return nil unless @item.send("#{attribute}?")

          href = item.send(attribute).url

          content = _("View %{attribute}", :attribute => @item.class.human_attribute_name(attribute).downcase)

          render "admin/helpers/preview", 
            :attribute => attribute, 
            :content => content, 
            :href => href, 
            :item => item
        end

        # override to make current page and any children disabled
        def expand_tree_into_select_field(items, attribute)
          String.new.tap do |html|
            items.each do |item|
              selected = "selected" if @item.send(attribute) == item.id
              disabled = 'disabled="disabled"' if @item == item || item.ancestors.include?(@item)
              inner = if item.ancestors.empty?
                item.to_label
              else
                "#{'&nbsp;' * item.ancestors.size * 2}&#8627; #{item.to_label}"
              end

              html << %{<option #{selected} #{disabled} value="#{item.id}">#{inner}</option>\n}
              html << expand_tree_into_select_field(item.children, attribute) unless item.children.empty?
            end
          end
        end

        alias_method_chain :typus_tree_field, :page
      end
    end

    def typus_tree_field_with_page(attribute, *args)
      options = args.extract_options!

      # scope page tree to section
      if @resource[:class] == Page
        section = @item.section
        options[:items] = section.present? ? section.pages.roots : []
      end

      typus_tree_field_without_page(attribute, options)
    end

    def render_tip(attribute)
      tip = @resource[:class].human_tip_text(attribute)

      if tip.present?
        content_tag(:em, :class => 'tip') { tip }.html_safe
      end
    end
  end
end
