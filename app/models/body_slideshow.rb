class BodySlideshow < ActiveRecord::Base
  belongs_to :page
  has_many :slides,
    :class_name => 'BodySlide',
    :dependent  => :destroy,
    :order      => 'position ASC'

  validates_presence_of :name
end
