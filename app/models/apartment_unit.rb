class ApartmentUnit < ActiveRecord::Base
  VACANCY_CLASS = [
    'Occupied',
    'Unoccupied'
  ]

  belongs_to :floor_plan, :class_name => 'ApartmentFloorPlan'

  has_many :amenities, :class_name => 'ApartmentUnitAmenity'

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
            :numericality => { :greater_than => 0 }, :allow_nil => true

  def apartment_community
    floor_plan.apartment_community
  end

  def square_footage
    "#{min_square_feet} to #{max_square_feet}"
  end
end
