class Property < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::Publishable
  include FriendlyId

  USE_BROCHURE_URL = 0
  USE_BROCHURE_FILE = 1

  BROCHURE_TYPE = [
    ['Enter a URL',   USE_BROCHURE_URL],
    ['Upload a file', USE_BROCHURE_FILE]
  ]

  PROPERTY_TYPE = [
      ['Apartment Community', 'ApartmentCommunity'],
      ['Home Community', 'HomeCommunity'],
      ['Project', 'Project']
  ]

  #:nocov:
  PROPERTY_TYPE.each do |_, type|
    define_method "#{type.underscore}?" do
      self.type == type
    end
  end
  #:nocov:

  friendly_id :id_and_title, use: [:scoped], :scope => :type

  ## TODO fix RF 2-1-16
  #search_methods :in_state
  def self.ransackable_scopes(auth_object = nil)
    [:in_state]
  end

  serialize :office_hours

  belongs_to :city
  belongs_to :county

  has_one :slideshow, :class_name => 'PropertySlideshow'

  has_and_belongs_to_many :property_features, -> { order(position: :asc) }

  has_many :landing_page_popular_orderings, :dependent => :destroy
  has_many :office_hours,       -> { order(:day) }
  has_many :property_amenities, -> { order(:position) }

  validates_presence_of :title, :city

  validates_length_of :short_title,       :maximum => 22, :allow_nil => true
  validates_length_of :short_description, :maximum => 40, :allow_nil => true

  validates_inclusion_of :brochure_type, :in => [USE_BROCHURE_URL, USE_BROCHURE_FILE]

  before_save :format_phone_number,        if: :phone_number?
  before_save :format_mobile_phone_number, if: :mobile_phone_number?

  has_attached_file :listing_image,
    :url             => '/system/:class/:id/:style.:extension',
    :styles          => { :square => '150x150#', :rect => '230x145#' },
    :default_style   => :square,
    :convert_options => { :all => '-quality 80 -strip' }

  has_attached_file :brochure,
    :url => '/system/:class/:id/brochure.:extension'

  has_attached_file :hero_image,
                    :url             => '/system/:class/:id/:attachment_name/:style.:extension',
                    :styles          => { :resized => '1020x325#' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }

  scope :mappable,         -> { where('latitude IS NOT NULL AND longitude IS NOT NULL') }
  scope :in_state,         -> (state_id) { where('city_id IN (SELECT id FROM cities WHERE cities.state_id = ?)', state_id) }
  scope :ordered_by_title, -> { order('properties.title ASC') }

  scope :duplicates, -> {
    joins('INNER JOIN properties AS other ON properties.title SOUNDS LIKE other.title')
      .where('properties.id != other.id AND properties.type = other.type')
      .order('title ASC')
  }


  def self.near(origin)
    scoped = by_distance(:origin => origin)

    if origin.is_a?(Property)
      scoped = scoped.where(['id != ?', origin.id])
    end

    scoped
  end

  def as_jmapping
    super.merge(:name => Rack::Utils.escape_html(title))
  end

  def typus_name
    title
  end

  def address(separator = ', ')
    [street_address, city].reject(&:blank?).join(separator)
  end

  def state
    city.state
  end

  def mappable?
    latitude.present? && longitude.present?
  end

  def uses_brochure_url?
    brochure_type == USE_BROCHURE_URL
  end

  def uses_brochure_file?
    brochure_type == USE_BROCHURE_FILE
  end

  def property_type
    read_attribute(:type)
  end

  def property_type=(type)
    write_attribute(:type, type)
  end

  def destroy_attached_files
    # no-op this because we need to keep attachments arround
  end

  def apartment?
    property_type == 'ApartmentCommunity'
  end
  alias_method :apartment_community?, :apartment?

  def home?
    property_type == 'HomeCommunity'
  end
  alias_method :home_community?, :home?

  def project?
    property_type == 'Project'
  end

  def short_name
    short_title.presence || title
  end

  def seo_link?
    seo_link_text.present? && seo_link_url.present?
  end

  def phone_number
    Bozzuto::PhoneNumber.new(read_attribute(:phone_number)).to_s
  end

  def mobile_phone_number
    Bozzuto::PhoneNumber.new(read_attribute(:mobile_phone_number)).to_s
  end

  private

  def id_and_title
    "#{id} #{title}"
  end

  def format_phone_number
    self.phone_number = Bozzuto::PhoneNumber.format(phone_number)
  end

  def format_mobile_phone_number
    self.mobile_phone_number = Bozzuto::PhoneNumber.format(mobile_phone_number)
  end
end
