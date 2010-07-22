class Property < ActiveRecord::Base
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

  belongs_to :city
  belongs_to :county  

  has_one :slideshow, :class_name => 'PropertySlideshow'
  has_one :mini_slideshow, :class_name => 'PropertyMiniSlideshow'

  has_and_belongs_to_many :property_features, :order => 'position ASC'

  validates_presence_of :title, :city
  validates_numericality_of :latitude, :longitude, :allow_nil => true
  validates_length_of :short_title, :maximum => 22, :allow_nil => true
  validates_inclusion_of :brochure_type, :in => [USE_BROCHURE_URL, USE_BROCHURE_FILE]

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_attached_file :listing_image,
    :url           => '/system/:class/:id/:style.:extension',
    :styles        => { :square => '150x150#', :rect => '230x145#' },
    :default_style => :square

  has_attached_file :brochure,
    :url => '/system/:class/:id/brochure.:extension'

  named_scope :near, lambda { |loc|
    returning({}) do |opts|
      opts[:origin]     = loc
      opts[:conditions] = ['id != ?', loc.id] if loc.is_a?(self)
      opts[:order]      = 'distance ASC'
    end
  }

  def typus_name
    title
  end

  def address
    [street_address, city].compact.join(', ')
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

  def to_jmapping
    <<-JS.html_safe
      { id: #{id}, point: { lat: #{latitude || 'null'}, lng: #{longitude || 'null'} }, category: '#{self.class}' }
    JS
  end

  def property_type
    read_attribute(:type)
  end

  def property_type=(type)
    write_attribute(:type, type)
  end


  private

  def id_and_title
    "#{id} #{title}"
  end
end
