class MastheadSlideshow < ActiveRecord::Base
  belongs_to :page
  has_many :slides,
    :class_name => 'MastheadSlide',
    :dependent  => :destroy,
    :order      => 'position ASC'

  validates_presence_of :name
end
