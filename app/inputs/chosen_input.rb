class ChosenInput < Formtastic::Inputs::SelectInput

  def input_html_options
    super.merge(:class => "chosen-input")
  end
end
