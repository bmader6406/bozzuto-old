class ApartmentUnit < ActiveRecord::Base
  VACANCY_CLASS = [
    'Occupied',
    'Unoccupied'
  ]

  belongs_to :floor_plan, :class_name => 'ApartmentFloorPlan'

  has_many :amenities, :class_name => 'ApartmentUnitAmenity'
  has_many :feed_files, :as => :feed_record

  validates :floor_plan,
            :presence => true

  validates :bedrooms,
            :bathrooms,
            :min_square_feet,
            :max_square_feet,
            :unit_rent,
            :market_rent,
            :min_rent,
            :max_rent,
            :avg_rent,
            :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true

  def apartment_community
    floor_plan.apartment_community
  end

  def square_footage
    "#{min_square_feet} to #{max_square_feet}"
  end

  def typus_name
    marketing_name.presence || "ApartmentUnit (ID: #{id})"
  end
end
