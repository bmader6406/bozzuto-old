class TomsBlogPost < ActiveRecord::Base
  validates_presence_of :title, :url, :published_at

  validates_attachment_presence :image

  has_attached_file :image,
    :url => '/system/:class/toms_blog_thumbnail_:id_:style.:extension',
    :styles => { :normal => '380x150#' },
    :default_style => :normal


  default_scope :order => 'published_at DESC'

  named_scope :latest, lambda { |limit|
    { :limit => limit }
  }
end
