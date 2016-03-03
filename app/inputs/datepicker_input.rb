class DatepickerInput < Formtastic::Inputs::StringInput
  def input_html_options
    super.merge(class: 'bootstrap-date')
  end
end
