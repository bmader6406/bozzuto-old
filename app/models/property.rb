class Property < ActiveRecord::Base
  include Bozzuto::Model::Property
  include Bozzuto::Model::Community

  PROPERTY_TYPE = [
    ['Apartment Community', 'ApartmentCommunity'],
    ['Home Community', 'HomeCommunity']
  ]

  friendly_id :title, use: [:history, :scoped], scope: [:type]

  scope :duplicates, -> {
    joins('INNER JOIN properties AS other ON properties.title SOUNDS LIKE other.title')
      .where('properties.id != other.id AND properties.type = other.type')
      .order('title ASC')
  }

  def property_type
    read_attribute(:type)
  end

  def property_type=(type)
    write_attribute(:type, type)
  end
end
