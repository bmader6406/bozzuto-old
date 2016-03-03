class DatetimePickerInput < Formtastic::Inputs::StringInput
  def input_html_options
    super.merge(class: 'bootstrap-datetime')
  end
end
