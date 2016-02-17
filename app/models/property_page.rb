class PropertyPage < ActiveRecord::Base
  self.abstract_class = true

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => 'property_id'
  belongs_to :home_community,      :foreign_key => 'property_id'
  belongs_to :project,             :foreign_key => 'property_id'

  validates_presence_of :property_id
end
