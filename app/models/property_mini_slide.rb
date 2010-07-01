class PropertyMiniSlide < ActiveRecord::Base
  belongs_to :property_mini_slideshow

  acts_as_list :scope => :property_mini_slideshow

  default_scope :order => 'position ASC'

  has_attached_file :image,
    :url => '/system/:class/:id/:style.:extension',
    :styles => { :slide => '230x144#' },
    :default_style => :slide

  validates_attachment_presence :image
end
