class Metro < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage

  acts_as_list

  has_neighborhood_listing_image

  has_many :areas, :dependent => :destroy

  def parent
    nil
  end

  def children
    areas
  end
end
