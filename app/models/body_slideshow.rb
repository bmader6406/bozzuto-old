class BodySlideshow < ActiveRecord::Base

  belongs_to :page

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'BodySlide',
    :dependent  => :destroy

  accepts_nested_attributes_for :slides, allow_destroy: true

  validates_presence_of :name
end
