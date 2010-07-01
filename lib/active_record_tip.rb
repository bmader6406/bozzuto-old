module ActiveRecord
  class Base
    def self.human_tip_text(attribute_key_name, options = {})
      key = :"#{self.name.underscore}.#{attribute_key_name}"

      I18n.translate(key, options.merge(:default => '', :scope => [:activerecord, :tips]))
    end
  end
end
