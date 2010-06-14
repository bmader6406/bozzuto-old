class Testimonial < ActiveRecord::Base
  validates_presence_of :name, :title, :quote
end
