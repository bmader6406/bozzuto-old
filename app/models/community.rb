class Community < Property
  belongs_to :local_info_feed, :class_name => 'Feed'

  def has_overview_bullets?
    (1..3).any? do |i|
      send("overview_bullet_#{i}").present?
    end
  end

  def local_info
    has_local_info? ? local_info_feed.items : []
  end

  def has_local_info?
    local_info_feed.present? && local_info_feed.items.any?
  end
end
