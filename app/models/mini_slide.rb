class MiniSlide < ActiveRecord::Base

  belongs_to :mini_slideshow

  acts_as_list :scope => :mini_slideshow

  default_scope -> { order(position: :asc) }

  has_attached_file :image,
    :url             => '/system/property_mini_slides/:id/:style.:extension',
    :styles          => { :slide => '230x145#' },
    :default_style   => :slide,
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  def typus_name
    "#{mini_slideshow.title} - Slide ##{position}"
  end
end
