class NewsPost < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable
  include Bozzuto::Homepage::FeaturableNews

  cattr_reader :per_page
  @@per_page = 10

  has_and_belongs_to_many :sections
  
  default_scope :order => 'published_at DESC'

  validates_presence_of :title, :body

  has_attached_file :image,
    :url             => '/system/:class/:id/:id_:style.:extension',
    :styles          => { :thumb => '150x150#' },
    :default_style   => :thumb,
    :convert_options => { :all => '-quality 80 -strip' }

  has_attached_file :home_page_image,
    :url             => '/system/:class/:id/home_page_image_:style_:id.:extension',
    :styles          => { :normal => '380x150#' },
    :default_style   => :normal,
    :default_url     => '/images/home-latest-news-placeholder.jpg',
    :convert_options => { :all => '-quality 80 -strip' }

  def typus_name
    title
  end
end
