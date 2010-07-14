class LandingPage < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  has_attached_file :masthead_image,
    :url => '/system/:class/:id/masthead_:style.:extension',
    :styles => { :resized => '230x222#' },
    :default_style => :resized
end
