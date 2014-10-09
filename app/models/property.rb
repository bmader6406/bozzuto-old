class Property < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::Publishable

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

  has_friendly_id :id_and_title,
    :use_slug => true,
    :scope => :type

  search_methods :in_state

  serialize :office_hours

  belongs_to :city
  belongs_to :county

  has_one :slideshow, :class_name => 'PropertySlideshow'

  has_and_belongs_to_many :property_features, :order => 'position ASC'

  has_many :landing_page_popular_orderings, :dependent => :destroy

  validates_presence_of :title, :city
  validates_length_of :short_title, :maximum => 22, :allow_nil => true
  validates_inclusion_of :brochure_type, :in => [USE_BROCHURE_URL, USE_BROCHURE_FILE]

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

  scope :mappable, :conditions => ['latitude IS NOT NULL AND longitude IS NOT NULL']

  scope :in_state, lambda { |state_id|
    {:conditions => ['city_id IN (SELECT id FROM cities WHERE cities.state_id = ?)', state_id]}
  }

  scope :ordered_by_title, :order => 'properties.title ASC'

  scope :duplicates,
    :joins      => 'INNER JOIN properties AS other ON properties.title SOUNDS LIKE other.title',
    :conditions => 'properties.id != other.id AND properties.type = other.type',
    :order      => 'title ASC'


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

  private

  def id_and_title
    "#{id} #{title}"
  end
end
