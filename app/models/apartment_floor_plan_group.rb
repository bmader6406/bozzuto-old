class ApartmentFloorPlanGroup < ActiveRecord::Base
  has_many :floor_plans,
    :class_name  => 'ApartmentFloorPlan',
    :foreign_key => :floor_plan_group_id,
    :dependent   => :destroy


  default_scope :order => 'position ASC'

  acts_as_list

  validates_presence_of :name


  def self.studio
    @studio ||= find_by_name 'Studio'
  end

  def self.one_bedroom
    @one_bedroom ||= find_by_name '1 Bedroom'
  end

  def self.two_bedrooms
    @two_bedroom ||= find_by_name '2 Bedrooms'
  end

  def self.three_bedrooms
    @three_bedrooms = find_by_name '3 or More Bedrooms'
  end

  def self.penthouse
    @penthouse = find_by_name 'Penthouse'
  end
end
