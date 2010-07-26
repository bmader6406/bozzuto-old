class HomePage < ActiveRecord::Base
  belongs_to :mini_slideshow
  has_many :slides,
    :class_name => 'HomePageSlide',
    :order      => 'position ASC'

  validates_presence_of :body
end
