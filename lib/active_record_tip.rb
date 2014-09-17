module ActiveRecord
  class Base
    def self.human_tip_text(attribute_key_name, options = {})
      defaults = self_and_descendants_from_active_record.map do |klass|
        :"#{klass.name.underscore}.#{attribute_key_name}"
      end

      defaults << options[:default] if options[:default]
      defaults << ''
      defaults.flatten!
      I18n.translate(defaults.shift, options.merge(:default => defaults, :scope => [:activerecord, :tips]))
    end

    def self.self_and_descendants_from_active_record
      klass = self
      classes = [klass]
      while klass != klass.base_class  
        classes << klass = klass.superclass
      end
      classes
    rescue
      # OPTIMIZE this rescue is to fix this test: ./test/cases/reflection_test.rb:56:in `test_human_name_for_column'
      #         # Appearantly the method base_class causes some trouble.
      #                 # It now works for sure.
      [self]
    end
  end
end
