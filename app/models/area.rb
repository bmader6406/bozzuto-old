class Area < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage

  acts_as_list :scope => :metro

  has_neighborhood_listing_image

  has_many :neighborhoods, :dependent => :destroy

  belongs_to :metro

  validates_presence_of :metro

  def parent
    metro
  end

  def children
    neighborhoods
  end
end
