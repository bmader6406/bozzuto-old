class HomePage < ActiveRecord::Base
  belongs_to :apartment_mini_slideshow, :class_name => 'MiniSlideshow'
  belongs_to :home_mini_slideshow, :class_name => 'MiniSlideshow'
  has_many :slides,
    :class_name => 'HomePageSlide',
    :order      => 'position ASC'

  validates_presence_of :body
end
