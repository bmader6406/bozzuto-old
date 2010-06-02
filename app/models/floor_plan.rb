class FloorPlan < ActiveRecord::Base
  belongs_to :floor_plan_group

  acts_as_list :scope => :floor_plan_group

  validates_presence_of :image,
    :category,
    :bedrooms,
    :bathrooms,
    :square_feet,
    :price,
    :floor_plan_group
  validates_numericality_of :bedrooms,
    :bathrooms,
    :square_feet,
    :price,
    :minimum => 0
end
