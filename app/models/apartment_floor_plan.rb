class ApartmentFloorPlan < ActiveRecord::Base
  USE_IMAGE_URL = 0
  USE_IMAGE_FILE = 1

  IMAGE_TYPE = [
    ['Enter a URL',   USE_IMAGE_URL],
    ['Upload a file', USE_IMAGE_FILE]
  ]

  before_validation :set_rent_prices

  belongs_to :floor_plan_group, :class_name => 'ApartmentFloorPlanGroup'
  belongs_to :apartment_community

  acts_as_list

  validates_presence_of :name,
    :floor_plan_group,
    :apartment_community

  validates_numericality_of :bedrooms,
    :bathrooms,
    :min_square_feet,
    :max_square_feet,
    :min_market_rent,
    :max_market_rent,
    :min_effective_rent,
    :max_effective_rent,
    :min_rent,
    :max_rent,
    :minimum => 0,
    :allow_nil => true

  validates_inclusion_of :featured, :rolled_up, :in => [true, false]

  has_attached_file :image,
    :url => '/system/:class/:id/:style.:extension',
    :styles => { :thumb => '160' }

  named_scope :in_group, lambda { |group|
    { :conditions => { :floor_plan_group_id => group.id } }
  }
  named_scope :largest,
    :conditions => 'max_square_feet IS NOT NULL',
    :order      => 'max_square_feet DESC',
    :limit      => 1

  named_scope :non_zero_min_rent, :conditions => 'min_rent > 0 OR min_rent IS NULL'


  def uses_image_url?
    image_type == USE_IMAGE_URL
  end

  def uses_image_file?
    image_type == USE_IMAGE_FILE
  end

  def actual_image
    uses_image_file? ? image.url : image_url
  end

  def actual_thumb
    uses_image_file? ? image.url(:thumb) : image_url
  end

  def set_rent_prices
    self.min_rent = if apartment_community.try(:use_market_prices?)
      min_market_rent
    else
      min_effective_rent
    end

    self.max_rent = if apartment_community.try(:use_market_prices?)
      max_market_rent
    else
      max_effective_rent
    end

    true
  end


  private

  def scope_condition
    "apartment_community_id = #{apartment_community_id} AND floor_plan_group_id = #{floor_plan_group_id}"
  end
end
