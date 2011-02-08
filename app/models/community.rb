class Community < Property
  include Bozzuto::SMSAble

  acts_as_archive :indexes => [:id]

  acts_as_list :column => 'featured_position'

  belongs_to :local_info_feed, :class_name => 'Feed'
  belongs_to :promo
  has_one :photo_set,
    :foreign_key => :property_id
  has_many :photos, :through => :photo_set
  has_one :dnr_configuration,
    :dependent   => :destroy,
    :foreign_key => :property_id
  has_many :videos,
    :foreign_key => :property_id,
    :order       => 'position ASC'

  [:features_page, :neighborhood_page, :contact_page].each do |page_type|
    has_one page_type, :class_name => "Property#{page_type.to_s.classify}",
      :foreign_key => :property_id

    define_method("#{page_type}?") do
      self.send(page_type).present?
    end
  end

  before_save :set_featured_postion

  named_scope :featured_order, {:order => 'featured DESC, featured_position ASC, title ASC'}

  named_scope :sort_for, lambda { |landing_page|
    if landing_page.respond_to?(:randomize_property_listings?)
      landing_page.randomize_property_listings? ?
        {:order => 'RAND(NOW())'} :
        {:order => 'properties.title ASC'}
    else
      {}
    end
  }

  def self.typus_fields_for(filter)
    result = super
    if result.present? && result['featured_position'].present?
      result['featured_position'] = :position
    end
    result
  end

  def has_overview_bullets?
    (1..3).any? do |i|
      send("overview_bullet_#{i}").present?
    end
  end

  def photo_groups
    @photo_groups ||= PhotoGroup.for_community(self)
  end

  def photo_groups_and_photos
    photo_groups.map do |photo_group|
      [photo_group, photo_group.photos.in_set(self.photo_set)]
    end
  end

  def local_info
    has_local_info? ? local_info_feed.items : []
  end

  def has_local_info?
    local_info_feed.present? && local_info_feed.items.any?
  end

  def has_active_promo?
    promo.present? && promo.active?
  end

  def has_media?
    photo_set.present? || videos.present?
  end

  # used by sms
  def phone_message
    "#{title} #{street_address}, #{city.name}, #{city.state.name} #{phone_number} Call for specials! #{website_url}"
  end

  protected

  def scope_condition
    "properties.city_id IN (SELECT id FROM cities WHERE cities.state_id = #{city.state_id}) AND properties.featured = 1"
  end

  def set_featured_postion
    if featured_changed?
      if featured?
        self.featured_position = bottom_position_in_list(self).to_i + 1
      else
        self.featured_position = nil
      end
    end
  end
end
