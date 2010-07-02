class HomePageSlide < ActiveRecord::Base
  acts_as_list

  default_scope :order => 'position ASC'

  belongs_to :home_page

  has_attached_file :image,
    :url => '/system/:class/slide_:id_:style.:extension',
    :styles => { :resized => '1100x380#' },
    :default_style => :resized

  validates_attachment_presence :image
end
