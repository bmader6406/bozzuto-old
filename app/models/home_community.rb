class HomeCommunity < ActiveRecord::Base
  include Bozzuto::Model::Property
  include Bozzuto::Model::Community
  include Bozzuto::AlgoliaSiteSearch

  cattr_reader :per_page
  @@per_page = 6

  has_many :homes
  has_many :featured_homes, -> { where(featured: true) }, class_name: 'Home'

  has_many :home_neighborhood_memberships, inverse_of: :home_community, dependent: :destroy
  has_many :home_neighborhoods, through: :home_neighborhood_memberships

  has_one :conversion_configuration, dependent: :destroy
  has_one :lasso_account,            dependent: :destroy
  has_one :green_package,            dependent: :destroy

  has_one :neighborhood,
          foreign_key: :featured_home_community_id,
          class_name:  'HomeNeighborhood',
          dependent:   :nullify

  has_attached_file :listing_promo,
    url:             '/system/:class/:id/:class_:id_:style.:extension',
    styles:          { display: '151x54#' },
    default_style:   :display,
    convert_options: { all: '-quality 80 -strip' }


  algolia_site_search if: :published do
    attribute :title, :zip_code, :listing_text, :neighborhood_description, :overview_text
    has_one_attribute :city, :name
    has_many_attribute :property_features, :name
    has_many_attribute :property_amenities, :primary_type
    has_many_attribute :home_neighborhoods, :name
    attribute :state do
      city.try(:state).try(:name)
    end
    attribute :type_ranking do
      1
    end
  end


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

  def to_s
    title
  end

  def description
    listing_text
  end

end
