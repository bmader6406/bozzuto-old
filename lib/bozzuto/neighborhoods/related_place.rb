module Bozzuto
  module Neighborhoods
    module RelatedPlace
      def self.extended(base)
        place_class       = base.to_s.sub('Related', '')
        place_name        = place_class.underscore.to_sym
        place_foreign_key = place_class.foreign_key.to_sym

        base.class_eval do
          acts_as_list :scope => place_foreign_key

          belongs_to place_name,
                     :inverse_of => :"related_#{place_name.to_s.pluralize}"

          belongs_to :"nearby_#{place_name}",
                     :class_name => place_class,
                     :inverse_of => :"#{place_name}_relations"

          validates_presence_of place_name, :"nearby_#{place_name}"

          validates_uniqueness_of :"nearby_#{place_foreign_key}", :scope => place_foreign_key

          validate :not_relating_to_self
        end

        base.class_eval <<-END
          private

          def not_relating_to_self
            if #{place_name} == nearby_#{place_name}
              errors.add(:nearby_#{place_name}, "can't be the same as #{place_class}")
            end
          end
        END
      end
    end
  end
end
