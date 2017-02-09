class Area < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  include Bozzuto::Neighborhoods::Slideshow
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage
  extend  Bozzuto::Neighborhoods::HasRelatedPlaces
  include Bozzuto::AlgoliaSiteSearch

  AREA_TYPE = [
    ['Neighborhoods', 'neighborhoods'],
    ['Communities', 'communities']
  ]

  acts_as_list :scope => :metro

  has_neighborhood_listing_image
  has_neighborhood_banner_image(:required => false)

  belongs_to :state

  has_many :neighborhoods, :dependent => :destroy

  has_many :area_memberships, -> { order('area_memberships.tier ASC') },
           :inverse_of => :area,
           :dependent  => :destroy

  has_many :apartment_communities, -> { order('area_memberships.tier ASC') },
           :through => :area_memberships

  belongs_to :metro


  algolia_site_search do
    attribute :name, :detail_description
    has_one_attribute :state, :name
    attribute :type_ranking do
      3
    end
  end


  accepts_nested_attributes_for :area_memberships, allow_destroy: true

  validates_presence_of :metro, :area_type

  validates_inclusion_of :area_type, :in => AREA_TYPE.map(&:last)

  scope :showing_communities,   -> { where(:area_type => 'communities') }
  scope :showing_neighborhoods, -> { where(:area_type => 'neighborhoods') }
  scope :position_asc,          -> { order(position: :asc) }

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

  def communities(reload = false)
    if children.nil? || children.empty?
      apartment_communities(reload).published
    else
      children.map { |c| c.communities(reload) }.flatten.uniq
    end
  end

  def tier_for(community)
    area_memberships.find_by(apartment_community_id: community.id).try(:tier)
  end

  def to_s
    name
  end

  def description
    detail_description
  end
end
