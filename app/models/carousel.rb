class Carousel < ActiveRecord::Base
  belongs_to :content, :polymorphic => true

  has_many :panels, -> { order('carousel_panels.position ASC') },
           :class_name => 'CarouselPanel',
           :dependent  => :destroy

  accepts_nested_attributes_for :panels

  validates_presence_of :name
end
