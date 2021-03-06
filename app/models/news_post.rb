class NewsPost < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable
  include Bozzuto::Homepage::FeaturableNews
  include Bozzuto::AlgoliaSiteSearch

  extend FriendlyId
  friendly_id :title, use: :slugged

  cattr_reader :per_page
  @@per_page = 10

  has_and_belongs_to_many :sections
  
  default_scope -> { order(published_at: :desc) }

  validates:title,
           :body,
           presence: true

  has_attached_file :image,
    :url             => '/system/:class/:id/:id_:style.:extension',
    :styles          => { :thumb => '150x150#' },
    :default_style   => :thumb,
    :convert_options => { :all => '-quality 80 -strip' }


  algolia_site_search if: :published do
    attribute :title, :body
    attribute :type_ranking do
      4
    end
  end


  do_not_validate_attachment_file_type :image

  def to_s
    title
  end

  def to_label
    title
  end

  def normalize_friendly_id(string)
    ret = Bozzuto::Model::SlugUrl.to_readable_url(string)
  end
end
