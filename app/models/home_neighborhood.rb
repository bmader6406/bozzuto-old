class HomeNeighborhood < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage

  acts_as_list

  has_neighborhood_listing_image
  has_neighborhood_banner_image

  belongs_to :featured_home_community,
             :class_name => 'HomeCommunity'

  has_many :home_neighborhood_memberships,
           :inverse_of => :home_neighborhood,
           :order      => 'home_neighborhood_memberships.position ASC',
           :dependent  => :destroy

  has_many :home_communities,
           :through => :home_neighborhood_memberships,
           :order   => 'home_neighborhood_memberships.position ASC'

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name,
                        :latitude,
                        :longitude

  validates_uniqueness_of :name

  named_scope :positioned,       :order => "home_neighborhoods.position ASC"
  named_scope :ordered_by_count, :order => "home_neighborhoods.home_communities_count DESC, home_neighborhoods.name ASC"

  after_save :update_home_communities_count

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

  def name_with_count
    if home_communities_count > 0
      "#{name} (#{home_communities_count})"
    else
      name
    end
  end

  def as_jmapping
    {
      :id                     => id,
      :point                  => jmapping_point,
      :category               => jmapping_category,
      :name                   => Rack::Utils.escape_html(name),
      :home_communities_count => home_communities_count
    }
  end

  protected

  def update_home_communities_count
    self.home_communities_count = communities(true).count
    send(:update_without_callbacks)
  end
end
