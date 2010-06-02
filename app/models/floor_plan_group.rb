class FloorPlanGroup < ActiveRecord::Base
  has_many :floor_plans
  belongs_to :community

  acts_as_list :scope => :community

  validates_presence_of :name
end
