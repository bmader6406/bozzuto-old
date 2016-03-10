module Bozzuto
  module Searches
    module PolymorphicJoin
      extend ActiveSupport::Concern

      included do
        private

        def foreign_key_type
          @foreign_key_type ||= foreign_key.to_s.gsub('_id', '_type')
        end

        def associated_fields
          Array(super) << foreign_key_type
        end

        def join_condition
          super.and derived_table[foreign_key_type].eq(main_class.name)
        end
      end
    end
  end
end
