class PropertySlideshow < ActiveRecord::Base

  validates_presence_of :name

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => 'property_id'
  belongs_to :home_community,      :foreign_key => 'property_id'
  belongs_to :project,             :foreign_key => 'property_id'

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'PropertySlide',
    :dependent  => :destroy

  alias_attribute :property_slides, :slides
end
