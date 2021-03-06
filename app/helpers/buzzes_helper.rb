module BuzzesHelper
  def mobile_check_box(form, object, field, label_text = nil)
    object_name = object.class.name.underscore

    label_text ||= I18n.t("helpers.label.#{object_name}.#{field}", :default => field.to_s.titleize)
    label_text = "#{buzz_check_box(form, object, field)}&nbsp;#{label_text}"

    form.label(field, raw(label_text))
  end

  private

  def buzz_check_box(form, object, field)
    form.check_box(field, :checked => object.include?(field.to_s))
  end
end
