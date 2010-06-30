class PropertySlideshow < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :property
  has_many :slides, :class_name => 'PropertySlide'
end
