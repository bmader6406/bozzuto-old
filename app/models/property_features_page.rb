class PropertyFeaturesPage < ActiveRecord::Base
  belongs_to :property
  validates_presence_of :property_id
end
