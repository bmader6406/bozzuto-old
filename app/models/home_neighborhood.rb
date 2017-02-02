class HomeNeighborhood < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage
  extend FriendlyId
  include Bozzuto::AlgoliaSiteSearch

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

  friendly_id :name, use: [:history]

  validates :name,
            presence:   true,
            uniqueness: true

  validates :latitude,
            :longitude,
            presence: true

  accepts_nested_attributes_for :home_neighborhood_memberships, allow_destroy: true


  algolia_site_search do
    attribute :name, :detail_description
  end


  scope :positioned,       -> { order("home_neighborhoods.position ASC") }
  scope :ordered_by_count, -> { order("home_neighborhoods.home_communities_count DESC, home_neighborhoods.name ASC") }

  def to_s
    name
  end

  def to_label
    to_s
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
