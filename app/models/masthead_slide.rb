class MastheadSlide < ActiveRecord::Base
  USE_IMAGE = 0
  USE_TEXT = 1
  USE_MINI_SLIDESHOW = 2

  SLIDE_TYPE = [
    ['Upload a file', USE_IMAGE],
    ['Enter text', USE_TEXT],
    ['Show first slide from mini slideshow', USE_MINI_SLIDESHOW]
  ]

  acts_as_list :scope => :masthead_slideshow

  belongs_to :masthead_slideshow
  belongs_to :mini_slideshow

  validates_presence_of :body, :slide_type
  validates_inclusion_of :slide_type,
    :in => [USE_IMAGE, USE_TEXT, USE_MINI_SLIDESHOW]

  has_attached_file :image,
    :url => '/system/:class/:id/slide_:id_:style.:extension',
    :styles => { :resized => '230x223#' },
    :default_style => :resized

  def uses_image?
    slide_type == USE_IMAGE
  end

  def uses_text?
    slide_type == USE_TEXT
  end

  def uses_mini_slideshow?
    slide_type == USE_MINI_SLIDESHOW
  end
end
