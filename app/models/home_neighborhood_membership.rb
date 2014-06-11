class HomeNeighborhoodMembership < ActiveRecord::Base
  acts_as_list

  belongs_to :home_neighborhood, :inverse_of => :home_neighborhood_memberships
  belongs_to :home_community,    :inverse_of => :home_neighborhood_memberships

  validates_presence_of :home_neighborhood, :home_community
  validates_uniqueness_of :home_community_id, :scope => :home_neighborhood_id

  after_save :update_home_communities_count

  delegate :update_home_communities_count, :to => :home_neighborhood
end
