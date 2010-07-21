class LeadershipGroup < ActiveRecord::Base
  acts_as_list

  has_many :leaders

  validates_presence_of :name
end
