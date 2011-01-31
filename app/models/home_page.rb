class HomePage < ActiveRecord::Base
  belongs_to :mini_slideshow
  has_many :slides,
    :class_name => 'HomePageSlide',
    :order      => 'position ASC'

  validates_presence_of :body

  has_attached_file :mobile_banner_image,
    :url => '/system/:class/mobile_banner_image_:id_:style.:extension',
    :styles => { :resized => '280x85#' },
    :default_style => :resized
end
