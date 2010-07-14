module BuzzesHelper
  def serialized_check_box(form, object, field)
    form.check_box(field, :checked => object.include?(field.to_s)) +
      form.label(field) +
      raw("<br />\n")
  end
end
