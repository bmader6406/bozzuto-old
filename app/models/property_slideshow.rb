class PropertySlideshow < ActiveRecord::Base
  belongs_to :property, polymorphic: true

  has_many :slides, -> { order(position: :asc) },
    class_name: 'PropertySlide',
    dependent:  :destroy

  validates_presence_of :name

  alias_attribute :property_slides, :slides

  def to_s
    name
  end

  def diff_attributes
    Chronolog::DiffRepresentation.new(self, includes: :slides).attributes
  end
end
