class Area < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage
  extend  Bozzuto::Neighborhoods::HasRelatedPlaces

  AREA_TYPE = [
    ['Neighborhoods', 'neighborhoods'],
    ['Communities', 'communities']
  ]

  acts_as_list :scope => :metro

  has_neighborhood_listing_image
  has_neighborhood_banner_image(:required => false)

  belongs_to :state

  has_many :neighborhoods, :dependent => :destroy

  has_many :area_memberships,
           :inverse_of => :area,
           :order      => 'area_memberships.position ASC',
           :dependent  => :destroy

  has_many :apartment_communities,
           :through => :area_memberships,
           :order   => 'area_memberships.position ASC'

  belongs_to :metro

  validates_presence_of :metro, :area_type

  validates_inclusion_of :area_type, :in => AREA_TYPE.map(&:last)

  named_scope :showing_communities,   :conditions => { :area_type => 'communities' }
  named_scope :showing_neighborhoods, :conditions => { :area_type => 'neighborhoods' }

  def parent
    metro
  end

  def children
    if shows_neighborhoods?
      neighborhoods
    else
      nil
    end
  end

  def shows_neighborhoods?
    area_type == 'neighborhoods'
  end

  def shows_communities?
    area_type == 'communities'
  end
end
