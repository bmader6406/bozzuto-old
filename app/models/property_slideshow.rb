class PropertySlideshow < ActiveRecord::Base

  belongs_to :property, polymorphic: true

  has_many :slides, -> { order(position: :asc) },
    class_name: 'PropertySlide',
    dependent:  :destroy

  validates_presence_of :name

  alias_attribute :property_slides, :slides
end
