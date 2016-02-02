class LeadershipGroup < ActiveRecord::Base

  acts_as_list

  default_scope -> { order(position: :asc) }

  has_many :leaderships, -> { order(position: :asc) },
           :dependent  => :destroy,
           :inverse_of => :leadership_group

  has_many :leaders, -> { order(position: :asc) },
           :through => :leaderships

  validates_presence_of :name
end
