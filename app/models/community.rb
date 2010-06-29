class Community < Property
  belongs_to :yelp_feed

  def local_reviews
    has_local_reviews? ? yelp_feed.items : []
  end

  def has_local_reviews?
    yelp_feed.present? && yelp_feed.items.any?
  end
end
