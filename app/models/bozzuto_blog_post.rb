class BozzutoBlogPost < ActiveRecord::Base
  validates_presence_of :header_url,
                        :title,
                        :url,
                        :published_at

  validates_format_of :header_url, :url,
    :with    => /^https?:\/\//,
    :message => 'is not a valid URL. Be sure to include http:// at the beginning'

  validates_attachment_presence :image

  has_attached_file :image,
    :url => '/system/:class/bozzuto_blog_post_thumbnail_:id_:style.:extension',
    :styles => { :normal => '380x150#' },
    :default_style => :normal


  default_scope :order => 'published_at DESC'

  named_scope :latest, lambda { |limit|
    { :limit => limit }
  }
end
