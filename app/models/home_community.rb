class HomeCommunity < Community
  cattr_reader :per_page
  @@per_page = 6

  has_many :homes, :dependent => :destroy
  has_many :featured_homes,
    :class_name => 'Home',
    :conditions => { :featured => true }

  has_attached_file :listing_promo,
    :url => '/system/:class/:id/:class_:id_:style.:extension',
    :styles => { :display => '151x54#' },
    :default_style => :display

  named_scope :ordered_by_title, :order => 'title ASC'
  default_scope :order => 'title ASC'

  def nearby_communities(limit = 6)
    @nearby_communities ||= HomeCommunity.mappable.near(self).all(:limit => limit)
  end
end
