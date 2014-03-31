class NeighborhoodMembership < ActiveRecord::Base
  acts_as_list :scope => :neighborhood

  belongs_to :neighborhood,
             :inverse_of => :neighborhood_memberships

  belongs_to :apartment_community,
             :inverse_of => :neighborhood_memberships

  validates_presence_of :neighborhood, :apartment_community

  validates_uniqueness_of :apartment_community_id, :scope => :neighborhood_id

  after_save :update_apartment_communities_count
  after_destroy :update_apartment_communities_count

  after_save :invalidate_apartment_floor_plan_cache!
  after_destroy :invalidate_apartment_floor_plan_cache!

  delegate :invalidate_apartment_floor_plan_cache!, :to => :neighborhood

  private

  def update_apartment_communities_count
    neighborhood.send(:update_apartment_communities_count)
  end
end
