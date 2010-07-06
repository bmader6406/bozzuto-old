class Community < Property
  belongs_to :yelp_feed

  def has_overview_bullets?
    (1..3).any? do |i|
      send("overview_bullet_#{i}").present?
    end
  end

  def local_reviews
    has_local_reviews? ? yelp_feed.items : []
  end

  def has_local_reviews?
    yelp_feed.present? && yelp_feed.items.any?
  end
end
