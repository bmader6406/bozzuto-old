class PropertySlide < ActiveRecord::Base
  belongs_to :property_slideshow

  acts_as_list :scope => :property_slideshow

  default_scope :order => 'position ASC'

  has_attached_file :image,
    :url => '/system/:class/:id/:style.:extension',
    :styles => { :slide => '870x375#', :mobile_thumb => '280x85#' },
    :default_style => :slide

  validates_attachment_presence :image
  validates_length_of :caption, :maximum => 128, :allow_nil => true
end
