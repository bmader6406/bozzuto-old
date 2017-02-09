class BozzutoBlogPost < ActiveRecord::Base
  include Bozzuto::AlgoliaSiteSearch

  default_scope -> { order(published_at: :desc) }

  has_attached_file :image,
    :url             => '/system/:class/bozzuto_blog_post_thumbnail_:id_:style.:extension',
    :styles          => { :normal => '380x150#' },
    :default_style   => :normal,
    :convert_options => { :all => '-quality 80 -strip' }


  algolia_site_search if: :published? do
    attribute :title, :header_title
    attribute :type_ranking do
      4
    end
  end


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

  def to_s
    title
  end

  def published?
    published_at? && published_at.past?
  end
end
