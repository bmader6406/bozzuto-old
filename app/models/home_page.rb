class HomePage < ActiveRecord::Base
  belongs_to :featured_property, :class_name => 'Property'

  validates_presence_of :body
end
