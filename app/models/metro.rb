class Metro < ActiveRecord::Base
  extend  Bozzuto::Seo
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage
  extend  Bozzuto::Neighborhoods::BannerImage
  include Bozzuto::AlgoliaSiteSearch

  acts_as_list

  has_neighborhood_listing_image
  has_neighborhood_banner_image(:required => false)

  has_many :areas, :dependent => :destroy

  algolia_site_search do
    attribute :name, :detail_description
    attribute :type_ranking do
      3
    end
  end

  def banner_image_attributes=(attributes)
    banner_image.clear if has_destroy_flag?(attributes) && !banner_image.dirty?
  end

  def parent
    nil
  end

  def children
    areas
  end

  def to_s
    name
  end

  def description
    detail_description
  end
end
