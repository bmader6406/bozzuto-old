class HomeNeighborhood < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage
  extend FriendlyId

  acts_as_list

  has_neighborhood_listing_image
  has_neighborhood_banner_image

  belongs_to :featured_home_community,
             :class_name => 'HomeCommunity'

  has_many :home_neighborhood_memberships, -> { order('home_neighborhood_memberships.position ASC') },
           :inverse_of => :home_neighborhood,
           :dependent  => :destroy

  has_many :home_communities, -> { order('home_neighborhood_memberships.position ASC') },
           :through => :home_neighborhood_memberships

  friendly_id :name, use: [:slugged, :history]

  validates_presence_of :name,
                        :latitude,
                        :longitude

  validates_uniqueness_of :name

  scope :positioned,       -> { order("home_neighborhoods.position ASC") }
  scope :ordered_by_count, -> { order("home_neighborhoods.home_communities_count DESC, home_neighborhoods.name ASC") }

  def to_s
    name
  end

  def typus_name
    name
  end

  def full_name
    "#{name} Homes"
  end

  def communities(reload = false)
    home_communities(reload).published
  end

  def has_communities?
    communities.any?
  end

  def as_jmapping
    {
      :id                => id,
      :point             => jmapping_point,
      :category          => jmapping_category,
      :name              => Rack::Utils.escape_html(name),
      :communities_count => home_communities_count
    }
  end

  def home_communities_count
    communities.count
  end
end
