class HomeCommunity < Community
  extend Bozzuto::Neighborhoods::ListingImage

  cattr_reader :per_page
  @@per_page = 6
  
  #acts_as_archive :indexes => [:id]

  has_neighborhood_listing_image :neighborhood_listing_image, :required => false

  after_save    :trigger_published_community_recount, :if => :published_changed?
  after_destroy :trigger_published_community_recount

  has_many :homes

  has_many :featured_homes,
           :class_name => 'Home',
           :conditions => { :featured => true }

  has_one :lasso_account,
          :foreign_key => :property_id,
          :dependent   => :destroy

  has_one :green_package, :dependent => :destroy

  has_one :neighborhood,
          :foreign_key => :featured_home_community_id,
          :class_name  => 'HomeNeighborhood',
          :dependent   => :nullify

  has_many :home_neighborhoods,
           :through => :home_neighborhood_memberships

  has_many :home_neighborhood_memberships,
           :inverse_of => :home_community,
           :dependent  => :destroy

  has_attached_file :listing_promo,
    :url             => '/system/:class/:id/:class_:id_:style.:extension',
    :styles          => { :display => '151x54#' },
    :default_style   => :display,
    :convert_options => { :all => '-quality 80 -strip' }


  scope :with_green_package, -> { joins(:green_package) } # TODO Check this.

  def nearby_communities(limit = 6)
    @nearby_communities ||= self.class.published.mappable.near(self).limit(limit)
  end

  def show_lasso_form?
    lasso_account.present?
  end

  def first_home_neighborhood
    home_neighborhoods.first
  end


  private

  def trigger_published_community_recount
    home_neighborhood_memberships.each(&:update_home_communities_count)
  end
end
