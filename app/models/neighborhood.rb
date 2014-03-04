class Neighborhood < ActiveRecord::Base
  extend Bozzuto::Neighborhoods::Place

  acts_as_list :scope => :area

  belongs_to :area
  belongs_to :state
  belongs_to :featured_apartment_community,
             :class_name => 'ApartmentCommunity'

  validates_presence_of :area, :state

  validates_attachment_presence :banner_image
end
