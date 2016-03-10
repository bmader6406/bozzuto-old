class PropertyPage < ActiveRecord::Base
  self.abstract_class = true

  belongs_to :property, polymorphic: true

  validates_presence_of :property

  def apartment_community
    property if property.is_a? ApartmentCommunity
  end

  def home_community
    property if property.is_a? HomeCommunity
  end
end
