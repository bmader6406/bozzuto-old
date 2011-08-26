class Rank < ActiveRecord::Base
  acts_as_list :scope => :rank_category

  validates_presence_of :rank_number, :year

  belongs_to :rank_category
end
