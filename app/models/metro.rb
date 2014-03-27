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
end
