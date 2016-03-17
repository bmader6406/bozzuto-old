class HomeCommunity < ActiveRecord::Base
  include Bozzuto::Model::Property
  include Bozzuto::Model::Community

  cattr_reader :per_page
  @@per_page = 6

  has_one :conversion_configuration, foreign_key: :property_id, dependent: :destroy # TODO rename FK

  has_many :homes
  has_many :featured_homes, -> { where(featured: true) }, class_name: 'Home'
  has_many :home_neighborhood_memberships, inverse_of: :home_community, dependent: :destroy
  has_many :home_neighborhoods, through: :home_neighborhood_memberships

  has_one :lasso_account, foreign_key: :property_id, dependent: :destroy # TODO Rename FK

  has_one :green_package, dependent: :destroy

  has_one :neighborhood,
          foreign_key: :featured_home_community_id,
          class_name:  'HomeNeighborhood',
          dependent:   :nullify

  # TODO This needs to be added into the home community admin
  has_attached_file :listing_promo,
    url:             '/system/:class/:id/:class_:id_:style.:extension',
    styles:          { display: '151x54#' },
    default_style:   :display,
    convert_options: { all: '-quality 80 -strip' }

  validates_attachment_content_type :listing_promo, content_type: /\Aimage\/.*\Z/

  accepts_nested_attributes_for :conversion_configuration

  scope :with_green_package, -> { joins(:green_package) } # TODO Check this.

  def nearby_communities(limit = 6)
    @nearby_communities ||= self.class.published.mappable.near(self).limit(limit)
  end

  def show_lasso_form?
    lasso_account.present?
  end

  def first_home_neighborhood
    home_neighborhoods.first
  end

  # Overwrite seo_link? from Bozzuto::Model::Property
  def seo_link?
    false
  end
end
