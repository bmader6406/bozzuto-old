class FloorPlanGroup < ActiveRecord::Base
  STUDIO = find_by_name 'Studio'
  ONEBED = find_by_name '1 Bedroom'
  TWOBED = find_by_name '2 Bedrooms'
  THREEBED = find_by_name '3 or More Bedrooms'
  PENTHOUSE = find_by_name 'Penthouse'

  has_many :floor_plans, :dependent => :destroy do
  end

  default_scope :order => 'position ASC'

  acts_as_list

  validates_presence_of :name
end
