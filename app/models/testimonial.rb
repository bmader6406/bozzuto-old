class Testimonial < ActiveRecord::Base
  belongs_to :section

  validates_presence_of :name, :title, :quote
end
