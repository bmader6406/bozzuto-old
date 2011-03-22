class Carousel < ActiveRecord::Base
  belongs_to :page

  has_many :panels,
    :class_name => 'CarouselPanel',
    :dependent  => :destroy

  validates_presence_of :name
end
