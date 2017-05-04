class HomeSectionSlide < ActiveRecord::Base
  acts_as_list

  belongs_to :home_page

  has_attached_file :image,
    url:             '/system/:class/:id/:style.:extension',
    styles:          { slide: '1100x375#' },
    default_style:   :slide,
    convert_options: { all: '-quality 80 -strip' }

  validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :home_page,
            :link_url,
            presence: true

  def to_s
    text || link_url
  end
end
