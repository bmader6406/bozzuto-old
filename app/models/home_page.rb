class HomePage < ActiveRecord::Base
  validates_presence_of :body

  has_one :carousel,
    :as        => :content,
    :dependent => :destroy

  has_many :slides,
    :class_name => 'HomePageSlide',
    :order      => 'position ASC'

  has_attached_file :mobile_banner_image,
    :url             => '/system/:class/mobile_banner_image_:id_:style.:extension',
    :styles          => { :resized => '280x85#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  def typus_name
    'Home Page'
  end
end
