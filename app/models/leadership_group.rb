class LeadershipGroup < ActiveRecord::Base
  acts_as_list

  has_many :leaders, :order => 'position ASC'

  validates_presence_of :name

  default_scope :order => 'position ASC'
end
