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
  end

  def parent
    nil
  end

  def children
    areas
  end
end
