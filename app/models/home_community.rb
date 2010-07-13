class HomeCommunity < Community
  cattr_reader :per_page
  @@per_page = 4

  has_many :homes, :dependent => :destroy
  has_many :featured_homes,
    :class_name => 'Home',
    :conditions => { :featured => true }

  named_scope :ordered_by_title, :order => 'title ASC'

  def nearby_communities(limit = 6)
    @nearby_communities ||= city.home_communities.near(self).all(:limit => limit)
  end
end
