class Community < ActiveRecord::Base
  belongs_to :city
  has_many :photos
  has_many :floor_plan_groups
  has_many :floor_plans, :through => :floor_plan_groups
  belongs_to :yelp_feed

  validates_presence_of :title, :subtitle, :city
  validates_numericality_of :latitude, :longitude, :allow_nil => true

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  mount_uploader :promo_image, ImageUploader

  named_scope :near, lambda { |loc|
    returning({}) do |opts|
      opts[:origin]     = loc
      opts[:conditions] = ['id != ?', loc.id] if loc.is_a? Community
      opts[:order]      = 'distance ASC'
    end
  }

  def nearby_communities(limit = 6)
    @nearby_communities ||= city.communities.near(self).all(:limit => limit)
  end

  def address
    [street_address, city].compact.join(', ')
  end

  def local_reviews
    yelp_feed.present? ? yelp_feed.items : []
  end
end
