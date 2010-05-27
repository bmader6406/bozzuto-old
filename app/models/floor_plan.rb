class FloorPlan < ActiveRecord::Base
  belongs_to :community

  validates_presence_of :image, :category, :bedrooms, :bathrooms, :square_feet, :price, :community
  validates_numericality_of :bedrooms, :bathrooms, :square_feet, :price, :minimum => 0
end
