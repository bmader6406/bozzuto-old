class PropertyPage < ActiveRecord::Base
  self.abstract_class = true
  belongs_to :property
  validates_presence_of :property_id
end
