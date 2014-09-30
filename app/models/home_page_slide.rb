class HomePageSlide < ActiveRecord::Base
  acts_as_list

  default_scope :order => 'position ASC'

  belongs_to :home_page

  has_attached_file :image,
    :url             => '/system/:class/slide_:id_:style.:extension',
    :styles          => { :resized => '1100x380#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  def typus_name
    "Home Page - Slide ##{position}"
  end
end
