class RelatedNeighborhood < ActiveRecord::Base
  acts_as_list :scope => :neighborhood_id

  belongs_to :neighborhood,
             :inverse_of => :related_neighborhoods

  belongs_to :nearby_neighborhood,
             :class_name => 'Neighborhood',
             :inverse_of => :neighborhood_relations

  validates_presence_of :neighborhood, :nearby_neighborhood

  validates_uniqueness_of :nearby_neighborhood_id, :scope => :neighborhood_id

  validate :not_relating_to_self


  private

  def not_relating_to_self
    if neighborhood == nearby_neighborhood
      errors.add(:nearby_neighborhood, "can't be the same as Neighborhood")
    end
  end
end
