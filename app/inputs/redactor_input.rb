class RedactorInput < Formtastic::Inputs::TextInput

  def input_html_options
    super.merge(:class => "redactor-input")
  end
end
