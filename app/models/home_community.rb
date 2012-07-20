class HomeCommunity < Community
  cattr_reader :per_page
  @@per_page = 6
  
  acts_as_archive :indexes => [:id]

  has_many :homes
  has_many :featured_homes,
    :class_name => 'Home',
    :conditions => { :featured => true }
  has_one :lasso_account, :foreign_key => :property_id

  has_attached_file :listing_promo,
    :url => '/system/:class/:id/:class_:id_:style.:extension',
    :styles => { :display => '151x54#' },
    :default_style => :display

  named_scope :ordered_by_title, :order => 'title ASC'
  default_scope :order => 'title ASC'

  def nearby_communities(limit = 6)
    @nearby_communities ||= HomeCommunity.published.mappable.near(self).all(:limit => limit)
  end

  def show_lasso_form?
    lasso_account.present?
  end
end
