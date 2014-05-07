class LeadershipGroup < ActiveRecord::Base
  acts_as_list

  has_many :leaderships,
           :dependent  => :destroy,
           :inverse_of => :leadership_group,
           :order      => 'position ASC'

  has_many :leaders,
           :through => :leaderships,
           :order   => 'position ASC'

  validates_presence_of :name

  default_scope :order => 'position ASC'
end
