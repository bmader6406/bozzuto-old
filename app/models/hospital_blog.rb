class HospitalBlog < ActiveRecord::Base
  extend  Bozzuto::Neighborhoods::ListingImage

  has_neighborhood_listing_image

  belongs_to :hospital_region

  validates_presence_of :title,
                        :hospital_region,
                        :url

  validates_uniqueness_of :hospital_region_id
end
