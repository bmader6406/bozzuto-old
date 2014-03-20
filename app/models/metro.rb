class Metro < ActiveRecord::Base
  extend Bozzuto::Neighborhoods::Place

  acts_as_list

  has_many :areas, :dependent => :destroy

  def parent
    nil
  end


  protected

  def calculate_apartment_communities_count
    areas(true).map(&:apartment_communities_count).sum
  end
end
