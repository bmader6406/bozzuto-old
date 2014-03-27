class Metro < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage

  acts_as_list

  has_many :areas, :dependent => :destroy

  def parent
    nil
  end

  def children
    areas
  end

  def memberships
    areas.map(&:memberships).flatten.uniq(&:apartment_community_id)
  end


  protected

  def calculate_apartment_communities_count
    areas(true).map(&:apartment_communities_count).sum
  end
end
