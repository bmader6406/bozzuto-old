class BodySlide < ActiveRecord::Base
  acts_as_list :scope => :body_slideshow

  default_scope :order => 'position ASC'

  belongs_to :body_slideshow

   has_attached_file :image,
     :url => '/system/:class/:id/slide_:id_:style.:extension',
     :styles => { :resized => '850x375#' },
     :default_style => :resized

   validates_attachment_presence :image
end
