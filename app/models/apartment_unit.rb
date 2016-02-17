class ApartmentUnit < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  VACANCY_CLASS = [
    'Occupied',
    'Unoccupied'
  ]

  belongs_to :floor_plan, :class_name => 'ApartmentFloorPlan'

  has_one :apartment_community, through: :floor_plan

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

  def name
    marketing_name.presence || external_cms_id
  end

  def to_s
    name
  end

  def bedrooms
    read_attribute(:bedrooms).presence || floor_plan.try(:bedrooms)
  end

  def bathrooms
    read_attribute(:bathrooms).presence || floor_plan.try(:bathrooms)
  end

  def rent
    value = case external_cms_type
    when 'vaultware'
      min_rent
    when 'property_link'
      market_rent
    else
      unit_rent
    end

    number_to_currency(value)
  end
end
