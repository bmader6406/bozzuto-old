class PressRelease < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable
  include Bozzuto::Homepage::FeaturableNews
  include Bozzuto::AlgoliaSiteSearch

  extend FriendlyId
  friendly_id :title, use: :slugged

  cattr_reader :per_page
  @@per_page = 15

  has_and_belongs_to_many :sections


  algolia_site_search if: :published do
    attribute :title, :body
    attribute :type_ranking do
      4
    end
  end


  validates :title,
            :body,
            presence: true

  default_scope -> { order(published_at: :desc) }

  def to_s
    title
  end

  def to_label
    to_s
  end

  def normalize_friendly_id(string)
    ret = Bozzuto::Model::SlugUrl.to_readable_url(string)
  end
end
