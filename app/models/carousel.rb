class Carousel < ActiveRecord::Base
  belongs_to :content, :polymorphic => true

  has_many :panels,
           :class_name => 'CarouselPanel',
           :order      => 'carousel_panels.position ASC',
           :dependent  => :destroy

  validates_presence_of :name
end
