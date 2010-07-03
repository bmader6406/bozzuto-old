class BodySlideshow < ActiveRecord::Base
  belongs_to :page
  has_many :slides,
    :class_name  => 'BodySlide',
    :foreign_key => :slideshow_id

  validates_presence_of :name
end
