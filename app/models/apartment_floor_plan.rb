class ApartmentFloorPlan < ActiveRecord::Base
  include Bozzuto::ExternalFeed::Model

  USE_IMAGE_URL = 0
  USE_IMAGE_FILE = 1

  IMAGE_TYPE = [
    ['Enter a URL',   USE_IMAGE_URL],
    ['Upload a file', USE_IMAGE_FILE]
  ]

  belongs_to :floor_plan_group, :class_name => 'ApartmentFloorPlanGroup'
  belongs_to :apartment_community

  has_many :apartment_units, :foreign_key => :floor_plan_id

  acts_as_list

  validates_presence_of :name,
                        :floor_plan_group,
                        :apartment_community

  validates_numericality_of :bedrooms,
                            :bathrooms,
                            :min_square_feet,
                            :max_square_feet,
                            :min_rent,
                            :max_rent,
                            :minimum => 0,
                            :allow_nil => true

  validates_inclusion_of :featured, :in => [true, false]

  has_attached_file :image,
    :url             => '/system/:class/:id/:style.:extension',
    :styles          => { :thumb => '160' },
    :convert_options => { :all   => '-quality 80 -strip' }

  scope :in_group,            -> (group) { where(:floor_plan_group_id => group.id) }
  scope :largest,             -> { where('max_square_feet IS NOT NULL').order('max_square_feet DESC').limit(1) }
  scope :non_zero_min_rent,   -> { where('min_rent > 0') }
  scope :ordered_by_min_rent, -> { order('min_rent ASC') }
  scope :ordered_by_max_rent, -> { order('max_rent DESC') }
  scope :available,           -> { where('available_units > 0') }
  scope :with_square_footage, -> { where('min_square_feet > 0') }

  alias_attribute :availability, :available_units

  def self.with_min_rent
    ordered_by_min_rent.first
  end

  def self.with_max_rent
    ordered_by_max_rent.first
  end

  def self.with_largest_square_footage
    largest.first
  end

  def self.externally_available
    non_zero_min_rent
  end

  def to_s
    name
  end

  def typus_name
    name
  end

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

  def disconnect_from_external_cms!
    self.external_cms_id   = nil
    self.external_cms_type = nil

    save
  end

  def available?
    available_units > 0
  end

  def square_footage
    "#{min_square_feet} to #{max_square_feet}"
  end

  private

  def scope_condition
    "apartment_community_id = #{apartment_community_id} AND floor_plan_group_id = #{floor_plan_group_id}"
  end
end
