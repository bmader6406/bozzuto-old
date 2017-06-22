class HomePageSlide < ActiveRecord::Base

  acts_as_list

  belongs_to :home_page

  has_attached_file :image,
    :url             => '/system/:class/slide_:id_:style.:extension',
    :styles          => { :resized => '1100x380#' },
    :default_style   => :original,
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  do_not_validate_attachment_file_type :image

  def to_s
    "Home Page - Slide ##{position}"
  end

  def to_label
    to_s
  end
end
