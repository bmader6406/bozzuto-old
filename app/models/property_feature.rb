class PropertyFeature < ActiveRecord::Base
  acts_as_list

  has_and_belongs_to_many :properties
  has_and_belongs_to_many :apartment_communities,
    :join_table => 'properties_property_features'
  has_and_belongs_to_many :home_communities,
    :join_table => 'properties_property_features'

  has_attached_file :icon,
    :url => '/system/:class/:id/icon_:style.:extension',
    :styles => { :resized => '44x44#' },
    :default_style => :resized

  validates_uniqueness_of :name
  validates_attachment_presence :icon
end
