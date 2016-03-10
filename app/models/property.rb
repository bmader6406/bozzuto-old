class Property < ActiveRecord::Base
  include Bozzuto::Model::Property

  PROPERTY_TYPE = [
    ['Apartment Community', 'ApartmentCommunity'],
    ['Home Community', 'HomeCommunity']
  ]

  friendly_id :title, use: [:history, :scoped], scope: [:type]

  serialize :office_hours

  belongs_to :county

  has_many :landing_page_popular_orderings, :dependent => :destroy
  has_many :office_hours,       -> { order(:day) }
  has_many :property_amenities, -> { order(:position) }, inverse_of: :property

  before_save :format_phone_number,        if: :phone_number?
  before_save :format_mobile_phone_number, if: :mobile_phone_number?

  scope :duplicates, -> {
    joins('INNER JOIN properties AS other ON properties.title SOUNDS LIKE other.title')
      .where('properties.id != other.id AND properties.type = other.type')
      .order('title ASC')
  }

  def property_type
    read_attribute(:type)
  end

  def property_type=(type)
    write_attribute(:type, type)
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
    Bozzuto::PhoneNumber.new(read_attribute(:mobile_phone_number)).to_s.presence || phone_number
  end

  private

  def format_phone_number
    self.phone_number = Bozzuto::PhoneNumber.format(phone_number)
  end

  def format_mobile_phone_number
    self.mobile_phone_number = Bozzuto::PhoneNumber.format(mobile_phone_number)
  end
end
