class BozzutoBlogPost < ActiveRecord::Base

  default_scope -> { order(published_at: :desc) }

  has_attached_file :image,
    :url             => '/system/:class/bozzuto_blog_post_thumbnail_:id_:style.:extension',
    :styles          => { :normal => '380x150#' },
    :default_style   => :normal,
    :convert_options => { :all => '-quality 80 -strip' }

  scope :latest, -> (n) { limit(n) }

  validates_presence_of :header_url,
                        :title,
                        :url,
                        :published_at

  validates_format_of :header_url, :url,
    :with    => /\Ahttps?:\/\//,
    :message => 'is not a valid URL. Be sure to include http:// at the beginning'

  do_not_validate_attachment_file_type :image

  validates_attachment_presence :image
end
