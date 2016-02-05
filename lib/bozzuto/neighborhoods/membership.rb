module Bozzuto
  module Neighborhoods
    module Membership
      def self.included(base)
        place_class       = base.to_s.sub('Membership', '')
        place_name        = place_class.underscore.to_sym
        place_foreign_key = place_class.foreign_key.to_sym

        base.class_eval do
          acts_as_list :scope => place_name

          belongs_to place_name, :inverse_of => :"#{place_name}_memberships"

          belongs_to :apartment_community, :inverse_of => :"#{place_name}_memberships"

          validates_presence_of place_name, :apartment_community

          validates_uniqueness_of :apartment_community_id, :scope => place_foreign_key

          validates_inclusion_of :tier, :in => [1, 2, 3, 4]

          after_save :invalidate_apartment_floor_plan_cache!
          after_destroy :invalidate_apartment_floor_plan_cache!

          delegate :invalidate_apartment_floor_plan_cache!, :to => place_name
        end
      end
    end
  end
end
