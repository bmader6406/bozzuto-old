class Area < ActiveRecord::Base
  include Bozzuto::Mappable
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::Neighborhoods::Place
  extend  Bozzuto::Neighborhoods::ListingImage

  AREA_TYPE = [
    ['Neighborhoods', 'neighborhoods'],
    ['Communities', 'communities']
  ]

  acts_as_list :scope => :metro

  has_neighborhood_listing_image

  belongs_to :state

  has_many :neighborhoods, :dependent => :destroy

  has_many :area_memberships,
           :inverse_of => :area,
           :order      => 'area_memberships.position ASC',
           :dependent  => :destroy

  has_many :apartment_communities,
           :through => :area_memberships,
           :order   => 'area_memberships.position ASC'

  belongs_to :metro

  validates_presence_of :metro, :area_type

  validates_inclusion_of :area_type, :in => AREA_TYPE.map(&:last)

  def parent
    metro
  end

  def children
    if shows_neighborhoods?
      neighborhoods
    else
      nil
    end
  end

  def shows_neighborhoods?
    area_type == 'neighborhoods'
  end

  def shows_communities?
    area_type == 'communities'
  end
end
