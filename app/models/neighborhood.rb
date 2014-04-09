class Neighborhood < ActiveRecord::Base
  extend  Bozzuto::Seo
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


  has_many :related_neighborhoods,
           :inverse_of => :neighborhood,
           :order      => 'related_neighborhoods.position ASC',
           :dependent  => :destroy

  has_many :nearby_neighborhoods,
           :through => :related_neighborhoods,
           :order   => 'related_neighborhoods.position ASC'

  has_many :neighborhood_relations,
           :class_name => 'RelatedNeighborhood',
           :inverse_of => :nearby_neighborhood,
           :dependent => :destroy


  validates_presence_of :area, :state

  validates_attachment_presence :banner_image

  def parent
    area
  end

  def children
    nil
  end

  def nearby_communities(reload = false)
    @nearby_communities = nil if reload

    @nearby_communities = nearby_neighborhoods.map(&:communities).flatten.uniq
  end
end
