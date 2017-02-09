class Award < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable
  include Bozzuto::Homepage::FeaturableNews
  include Bozzuto::AlgoliaSiteSearch

  cattr_reader :per_page
  @@per_page = 15

  has_and_belongs_to_many :sections

  validates :title,
            presence: true

  has_attached_file :image,
    :url             => '/system/:class/:id/:class_:id_:style.:extension',
    :styles          => { :thumb => '55x55#', :resized => '150x150#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }


  algolia_site_search if: :published do
    attribute :title, :body
    attribute :type_ranking do
      5
    end
  end


  do_not_validate_attachment_file_type :image

  default_scope -> { order(published_at: :desc) }

  def to_s
    title
  end

  def to_label
    to_s
  end
end
