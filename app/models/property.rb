class Property < ActiveRecord::Base
  include Bozzuto::Publishable

  belongs_to :city
  belongs_to :county

  has_one :slideshow, :class_name => 'PropertySlideshow'
  has_one :mini_slideshow, :class_name => 'PropertyMiniSlideshow'

  has_and_belongs_to_many :property_features

  validates_presence_of :title, :city
  validates_numericality_of :latitude, :longitude, :allow_nil => true

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  has_attached_file :listing_image,
    :url           => '/system/:class/:id/:style.:extension',
    :styles        => { :square => '150x150#' },
    :default_style => :square

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
end
