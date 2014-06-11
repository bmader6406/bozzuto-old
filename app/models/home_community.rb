class HomeCommunity < Community
  cattr_reader :per_page
  @@per_page = 6
  
  acts_as_archive :indexes => [:id]


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

  has_many :home_neighborhood_memberships,
           :inverse_of => :home_community,
           :dependent  => :destroy

  has_attached_file :listing_promo,
    :url             => '/system/:class/:id/:class_:id_:style.:extension',
    :styles          => { :display => '151x54#' },
    :default_style   => :display,
    :convert_options => { :all => '-quality 80 -strip' }


  named_scope :with_green_package,
    :joins => 'INNER JOIN green_packages ON properties.id = green_packages.home_community_id'

  default_scope :order => 'title ASC'


  def nearby_communities(limit = 6)
    @nearby_communities ||= HomeCommunity.published.mappable.near(self).all(:limit => limit)
  end

  def show_lasso_form?
    lasso_account.present?
  end
end
