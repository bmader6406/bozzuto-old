class PropertyMiniSlide < ActiveRecord::Base
  belongs_to :property_slideshow

  acts_as_list :scope => :property_slideshow

  has_attached_file :image,
    :url => '/system/:class/:id/:style.:extension',
    :styles => { :slide => '230x144#' },
    :default_style => :slide

  validates_attachment_presence :image
end
