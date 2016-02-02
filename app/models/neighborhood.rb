class Neighborhood < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  include Bozzuto::Neighborhoods::Slideshow
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage
  extend  Bozzuto::Neighborhoods::HasRelatedPlaces

  acts_as_list :scope => :area

  has_neighborhood_listing_image
  has_neighborhood_banner_image

  belongs_to :area
  belongs_to :state
  belongs_to :featured_apartment_community,
             :class_name => 'ApartmentCommunity'

  has_many :neighborhood_memberships, -> { order('neighborhood_memberships.tier ASC') },
           :inverse_of => :neighborhood,
           :dependent  => :destroy

  has_many :apartment_communities, -> { order('neighborhood_memberships.tier ASC') },
           :through => :neighborhood_memberships

  validates_presence_of :area, :state

  def parent
    area
  end

  def children
    nil
  end

  def tier_for(community)
    neighborhood_memberships.find_by_apartment_community_id(community.id).try(:tier)
  end
end
