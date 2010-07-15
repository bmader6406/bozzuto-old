class MastheadSlide < ActiveRecord::Base
  USE_IMAGE = 0
  USE_TEXT = 1
  USE_PROPERTY = 2

  SLIDE_TYPE = [
    ['Upload a file', USE_IMAGE],
    ['Enter text', USE_TEXT],
    ['Show a featured property', USE_PROPERTY]
  ]

  acts_as_list :scope => :masthead_slideshow

  belongs_to :masthead_slideshow
  belongs_to :featured_property,
    :class_name => 'Property'
  belongs_to :featured_apartment_community,
    :class_name => 'Property',
    :foreign_key => :featured_property_id
  belongs_to :featured_home_community,
    :class_name => 'Property',
    :foreign_key => :featured_property_id
  belongs_to :featured_project,
    :class_name => 'Property',
    :foreign_key => :featured_property_id

  validates_presence_of :body, :slide_type
  validates_inclusion_of :slide_type, :in => [USE_IMAGE, USE_TEXT, USE_PROPERTY]

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

  def uses_featured_property?
    slide_type == USE_PROPERTY
  end
end
