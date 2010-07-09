class Community < Property
  include Bozzuto::SMSAble

  belongs_to :local_info_feed, :class_name => 'Feed'
  has_one :photo_set, :foreign_key => :property_id
  has_many :videos,
    :foreign_key => :property_id,
    :order       => 'position ASC'

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

  # used by sms
  def phone_message
    "#{title}\n#{street_address}, #{city.name}, #{city.state.name}\n#{website_url}"
  end
end
