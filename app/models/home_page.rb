class HomePage < ActiveRecord::Base

  has_one :carousel,
    :as        => :content,
    :dependent => :destroy

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'HomePageSlide'

  has_attached_file :mobile_banner_image,
    :url             => '/system/:class/mobile_banner_image_:id_:style.:extension',
    :styles          => { :resized => '280x85#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :mobile_banner_image

  validates :body,
            presence: true

  accepts_nested_attributes_for :slides, allow_destroy: true

  def to_s
    'Home Page'
  end

  def to_label
    to_s
  end
end
