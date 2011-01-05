class Community < Property
  include Bozzuto::SMSAble
  
  acts_as_archive :indexes => [:id]
  
  acts_as_list :column => 'featured_position'

  belongs_to :local_info_feed, :class_name => 'Feed'
  belongs_to :promo
  has_one :photo_set,
    :foreign_key => :property_id
  has_one :dnr_configuration,
    :dependent   => :destroy,
    :foreign_key => :property_id
  has_many :videos,
    :foreign_key => :property_id,
    :order       => 'position ASC'
  has_one :features_page, :class_name => 'PropertyFeaturesPage',
    :foreign_key => :property_id
    
  before_save :set_featured_postion
  
  named_scope :featured_order, {:order => 'featured DESC, featured_position ASC, title ASC'}

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

  def local_info
    has_local_info? ? local_info_feed.items : []
  end

  def has_local_info?
    local_info_feed.present? && local_info_feed.items.any?
  end

  def has_active_promo?
    promo.present? && promo.active?
  end
  
  def features_page?
    features_page.present?
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
