module Bozzuto
  module Neighborhoods
    module HasRelatedPlaces
      def self.extended(base)
        place_name        = base.to_s.underscore.to_sym
        plural_place_name = place_name.to_s.pluralize.to_sym

        related_table = :"related_#{place_name.to_s.pluralize}"

        base.class_eval do
          has_many related_table, -> { order("#{related_table}.position ASC") },
                   :inverse_of => place_name,
                   :dependent  => :destroy

          has_many :"nearby_#{plural_place_name}", -> { order("#{related_table}.position ASC") },
                   :through => related_table

          has_many :"#{place_name}_relations",
                   :class_name => "Related#{base}",
                   :inverse_of => :"nearby_#{place_name}",
                   :dependent  => :destroy
        end

        base.class_eval <<-END
          def nearby_communities(reload = false)
            @nearby_communities = nil if reload

            @nearby_communities = nearby_#{plural_place_name}.map(&:communities).flatten.uniq
          end
        END
      end
    end
  end
end
