module Bozzuto
  class FormBuilder < ActionView::Helpers::FormBuilder
    def text_input(method, options = {})
      label_text = options.delete(:label) || method.to_s.humanize
      "<p>#{label(method, label_text)}<br />#{text_field(method, options)}".html_safe
    end
  end
end
