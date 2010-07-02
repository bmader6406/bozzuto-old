class HomePage < ActiveRecord::Base
  belongs_to :featured_property, :class_name => 'Property'
  has_many :slides, :class_name => 'HomePageSlide'

  validates_presence_of :body
end
