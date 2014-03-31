class Neighborhood < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage

  acts_as_list :scope => :area

  has_neighborhood_listing_image

  belongs_to :area
  belongs_to :state
  belongs_to :featured_apartment_community,
             :class_name => 'ApartmentCommunity'

  has_many :neighborhood_memberships,
           :inverse_of => :neighborhood,
           :order      => 'neighborhood_memberships.position ASC',
           :dependent  => :destroy

  has_many :apartment_communities,
           :through => :neighborhood_memberships,
           :order   => 'neighborhood_memberships.position ASC'

  validates_presence_of :area, :state

  validates_attachment_presence :banner_image

  def parent
    area
  end

  def children
    nil
  end

  def communities(reload = true)
    apartment_communities(reload)
  end
end
