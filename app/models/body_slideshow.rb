class BodySlideshow < ActiveRecord::Base

  belongs_to :page

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'BodySlide',
    :dependent  => :destroy

  validates_presence_of :name
end
