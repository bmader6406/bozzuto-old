class PropertySlide < ActiveRecord::Base

  acts_as_list :scope => :property_slideshow

  belongs_to :property_slideshow

  has_attached_file :image,
    :url             => '/system/:class/:id/:style.:extension',
    :styles          => { :slide => '870x375#', :mobile_thumb => '280x85#', :thumb => '55x55#' },
    :default_style   => :slide,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  validates :image, :attachment_presence => true

  validates_length_of :caption, :maximum => 128, :allow_nil => true

  def to_s
    "#{property_slideshow.name} - Slide ##{position}"
  end

  def typus_name
    to_s
  end
end
