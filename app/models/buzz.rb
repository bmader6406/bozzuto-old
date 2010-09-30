class Buzz < ActiveRecord::Base
  validates_presence_of :email
  validates_email_format_of :email

  %w(buzzes affiliations).each do |field|
    define_method(field) do 
      read_attribute(field).to_s.split(",")
    end

    define_method("formatted_#{field}") do
      send(field).join(', ').gsub(/_/, ' ')
    end

    define_method("#{field}=") do |value|
      write_attribute(field, convert_checkboxes_to_string(value))
    end
  end


  private

  def convert_checkboxes_to_string(value)
    case value
    when Hash then value.reject { |k,v| v == "0" || v == 0 || !v }.keys.join(",")
    when Array then value.join(",")
    else value.to_s
    end
  end
end
