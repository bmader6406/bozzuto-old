class PropertyMiniSlideshow < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => 'property_id'
  belongs_to :home_community, :foreign_key => 'property_id'
  belongs_to :project, :foreign_key => 'property_id'

  has_many :slides, :class_name => 'PropertySlide'
end
