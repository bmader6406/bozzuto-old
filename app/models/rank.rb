class Rank < ActiveRecord::Base
  YEAR = (1988..(Time.now.year + 1)).to_a.reverse

  validates_presence_of :rank_number, :year

  validates_numericality_of :rank_number,
    :only_integer => true,
    :greater_than => 0

  belongs_to :rank_category

  named_scope :ordered, :order => 'year DESC'
end
