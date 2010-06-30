class Home < ActiveRecord::Base
  acts_as_list :scope => :home_community

  belongs_to :home_community
  has_many :floor_plans, :class_name => 'HomeFloorPlan'

  default_scope :order => 'position ASC'

  validates_presence_of :home_community, :bedrooms, :bathrooms
  validates_inclusion_of :featured, :in => [true, false]

  validates_numericality_of :bedrooms, :bathrooms, :minimum => 0
end
