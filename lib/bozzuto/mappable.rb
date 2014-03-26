module Bozzuto
  module Mappable
    def self.extended(base)
      base.class_eval do
        acts_as_mappable :lat_column_name => :latitude,
                         :lng_column_name => :longitude

        validates_numericality_of :latitude, :greater_than_or_equal_to => -90.0,
                                             :less_than_or_equal_to    => 90.0,
                                             :allow_nil                => true

        validates_numericality_of :longitude, :greater_than_or_equal_to => -180.0,
                                              :less_than_or_equal_to    => 180.0,
                                              :allow_nil                => true

        def as_jmapping
          {
            :id       => id,
            :category => jmapping_category,
            :point    => jmapping_point
          }
        end

        def jmapping_category
          self.class.to_s
        end

        def jmapping_point
          {
            :lat => latitude || nil,
            :lng => longitude || nil,
          }
        end
      end
    end
  end
end
