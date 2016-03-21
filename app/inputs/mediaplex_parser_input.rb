class MediaplexParserInput < Formtastic::Inputs::TextInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      label_html <<
        parser_text_area <<
        parser_button <<
        parser_errors
    end
  end

  def parser_text_area
    builder.text_area method, input_html_options.merge(rows: 8)
  end

  def parser_button
    builder.button "Find Values", type: :button, class: 'button'
  end
  
  def parser_errors
    builder.template.content_tag :p,
                                 nil,
                                 class: [
                                   "inline-errors",
                                   "multiplex_parser_errors"
                                 ]
  end

  def wrapper_html_options
    new_class = [super[:class], "text"].compact.join(" ")
    super.merge(:class => new_class)
  end
end
