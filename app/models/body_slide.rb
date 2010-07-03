class BodySlide < ActiveRecord::Base
  acts_as_list :scope => :slideshow

  default_scope :order => 'position ASC'

  belongs_to :slideshow, :class_name => 'BodySlideshow'

   has_attached_file :image,
     :url => '/styles/:class/:id/slide_:id_:style.:jpg',
     :styles => { :resized => '850x375#' },
     :default_style => :resized

   validates_attachment_presence :image
end
