class Community < Property
  include Bozzuto::SMSAble
  extend FriendlyId

  #acts_as_archive :indexes => [:id]

  acts_as_list :column => 'featured_position'

  belongs_to :local_info_feed, :class_name => 'Feed'
  belongs_to :promo
  belongs_to :twitter_account

  has_many :photos,
           :foreign_key => :property_id,
           :dependent   => :destroy

  has_one :dnr_configuration,
    :dependent   => :destroy,
    :foreign_key => :property_id

  has_many :videos, -> { order(position: :asc) },
    :foreign_key => :property_id

  has_one :conversion_configuration,
    :dependent   => :destroy,
    :foreign_key => :property_id

  [:features_page, :neighborhood_page, :contact_page, :tours_page, :retail_page].each do |page_type|
    has_one page_type,
      :class_name  => "Property#{page_type.to_s.classify}",
      :foreign_key => :property_id

    define_method("#{page_type}?") do
      self.send(page_type).present?
    end
  end

  before_save :set_featured_postion

  scope :featured_order,       -> { order('featured DESC, featured_position ASC, title ASC') }
  scope :with_twitter_account, -> { where('twitter_account_id > 0') }

  scope :sort_for, -> (landing_page) {
    #:nocov:
    if landing_page.respond_to?(:randomize_property_listings?)
      order(landing_page.randomize_property_listings? ? 'RAND(NOW())' : 'properties.title ASC')
    else
      all
    end
    #:nocov:
  }

  delegate :latest_tweet, :to => :twitter_account, :allow_nil => true

  def self.typus_fields_for(filter)
    #:nocov:
    result = super
    if result.present? && result['featured_position'].present?
      result['featured_position'] = :position
    end
    result
    #:nocov:
  end

  def overview_bullets
    [overview_bullet_1, overview_bullet_2, overview_bullet_3].reject(&:blank?)
  end

  def has_overview_bullets?
    overview_bullets.any?
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
    photos.any? || videos.any?
  end

  def grouped_photos
    photos.positioned.grouped
  end

  # used by sms
  def phone_message
    "#{title} #{street_address}, #{city.name}, #{city.state.name} #{phone_number} Call for specials! #{website_url}"
  end

  def mobile_phone_number
    super.presence || phone_number
  end

  def twitter_handle
    twitter_account.try(:username)
  end


  protected

  def scope_condition
    "properties.city_id IN (SELECT id FROM cities WHERE cities.state_id = #{city.state_id}) AND properties.featured = 1"
  end

  def add_to_list_bottom
    # no-op. this is called after the before_save #set_featured_position callback
    # on create, which causes a featured_position of 1 to be set by default.
    # override here to prevent that from happening
  end

  def set_featured_postion
    if featured_changed? || new_record?
      if featured?
        except = new_record? ? nil : self
        self.featured_position = bottom_position_in_list(except).to_i + 1
      else
        self.featured_position = nil
      end
    end
  end
end
