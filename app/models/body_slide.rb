class BodySlide < ActiveRecord::Base
  acts_as_list :scope => :body_slideshow

  belongs_to :body_slideshow
  belongs_to :property

  has_attached_file :image,
    :url => '/system/:class/:id/slide_:id_:style.:extension',
    :styles => { :resized => '840x375#' },
    :default_style => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  validates :image, attachment_presence: true

  def typus_name
    slideshow_name = "#{body_slideshow.name} - " if body_slideshow.present?

    "#{slideshow_name}Slide ##{position}"
  end
end
