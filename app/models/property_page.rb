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

  def show_contact_callout?
    true
  end

  def to_s
    [
      self.class.name.titleize,
      'for',
      property.to_s
    ].join(' ')
  end
end
