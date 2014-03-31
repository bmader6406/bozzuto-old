class ApartmentFloorPlanGroup < ActiveRecord::Base
  DISPLAY_LIMIT = 8

  has_many :floor_plans,
           :class_name  => 'ApartmentFloorPlan',
           :foreign_key => :floor_plan_group_id,
           :dependent   => :destroy

  default_scope :order => 'position ASC'

  named_scope :except, lambda { |group|
    { :conditions => ['id != ?', group.id] }
  }

  acts_as_list

  validates_presence_of :name
  
  def list_name
    I18n.t!(:"apartment_floor_plan_group.#{cache_name}.list_name")
  end

  def short_name
    I18n.t!(:"apartment_floor_plan_group.#{cache_name}.short_name")
  end

  def plural_name
    name.pluralize
  end

  def cache_name
    case self
    when self.class.studio         then 'studio'
    when self.class.one_bedroom    then 'one_bedroom'
    when self.class.two_bedrooms   then 'two_bedrooms'
    when self.class.three_bedrooms then 'three_bedrooms'
    when self.class.penthouse      then 'penthouse'
    else
      raise "Unknown group: #{self}"
    end
  end

  class << self
    def studio
      find_by_name 'Studio'
    end

    def one_bedroom
      find_by_name '1 Bedroom'
    end

    def two_bedrooms
      find_by_name '2 Bedrooms'
    end

    def three_bedrooms
      find_by_name '3 or More Bedrooms'
    end

    def penthouse
      find_by_name 'Penthouse'
    end
  end
end
