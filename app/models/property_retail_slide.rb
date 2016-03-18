class PropertyRetailSlide < ActiveRecord::Base
  belongs_to :property_retail_page

  acts_as_list scope: :property_retail_page

  has_attached_file :image,
    url:             '/system/:class/:id/:style.:extension',
    styles:          { slide: '870x375#', mobile_thumb: '280x85#', thumb: '55x55#' },
    default_style:   :slide,
    convert_options: { all: '-quality 80 -strip' }

  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :property_retail_page,
            :name,
            presence: true

  def to_s
    name
  end

  def typus_name
    name
  end
end
