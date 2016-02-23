class ImageInput < Formtastic::Inputs::FileInput

  def to_html
    input_wrapping { image_input_html }
  end

  private

  def image_input_html
    "".tap do |html|
      html << file_input

      if file_present?
        html << link_to_file
      end
    end.html_safe
  end

  def file_present?
    object.send("#{method}?")
  end

  def file_input
    label_html << builder.file_field(method, input_html_options)
  end

  def link_to_file
    "<p>" << file_label << file_link << "</p>"
  end

  def file_label
    "Current File: "
  end

  def file_link
    template.link_to(file_name, file_url, :target => :blank)
  end

  def file_name
    object.send("#{method}_file_name")
  end

  def file_url
    file.send(:url)
  end

  def file
    object.send(method)
  end
end
