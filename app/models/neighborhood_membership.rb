class NeighborhoodMembership < ActiveRecord::Base
  acts_as_list :scope => :neighborhood

  belongs_to :neighborhood,
             :inverse_of => :neighborhood_memberships

  belongs_to :apartment_community,
             :inverse_of => :neighborhood_memberships

  validates_presence_of :neighborhood, :apartment_community

  validates_uniqueness_of :apartment_community_id, :scope => :neighborhood_id
end
