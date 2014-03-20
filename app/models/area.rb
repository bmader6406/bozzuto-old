class Area < ActiveRecord::Base
  extend Bozzuto::Neighborhoods::Place

  acts_as_list :scope => :metro

  has_many :neighborhoods, :dependent => :destroy

  belongs_to :metro

  validates_presence_of :metro

  def parent
    metro
  end


  protected

  def calculate_apartment_communities_count
    neighborhoods(true).map(&:apartment_communities_count).sum
  end
end
