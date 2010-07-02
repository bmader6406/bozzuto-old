class HomePage < ActiveRecord::Base
  belongs_to :featured_property, :class_name => 'Property'

  validates_presence_of :body

  has_attached_file :banner_image,
    :url => '/system/:class/:id/:style_banner_image.:extension',
    :styles => { :resized => '1100x375#' },
    :default_style => :resized

  validates_attachment_presence :banner_image
end
