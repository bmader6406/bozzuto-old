class ApartmentCommunity < Property
  has_many :photos
  has_many :floor_plan_groups
  has_many :floor_plans, :through => :floor_plan_groups
  belongs_to :yelp_feed

  validates_inclusion_of :use_market_prices, :in => [true, false]

  mount_uploader :promo_image, ImageUploader

  def nearby_communities(limit = 6)
    @nearby_communities ||= city.apartment_communities.near(self).all(:limit => limit)
  end

  def local_reviews
    has_local_reviews? ? yelp_feed.items : []
  end

  def has_local_reviews?
    yelp_feed.present? && yelp_feed.items.any?
  end
end
