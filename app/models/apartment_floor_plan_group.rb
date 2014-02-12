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
    if name =~ /^(\d+) .*Bedroom/i
      "#{$1}BR"
    else
      name.pluralize
    end
  end

  def name_for_cache
    case self
    when self.class.studio         then 'studio'
    when self.class.one_bedroom    then '1_bedroom'
    when self.class.two_bedrooms   then '2_bedroom'
    when self.class.three_bedrooms then '3_bedroom'
    when self.class.penthouse      then 'penthouse'
    else
      raise "Unknown group: #{self}"
    end
  end

  def plural_name
    name.pluralize
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
