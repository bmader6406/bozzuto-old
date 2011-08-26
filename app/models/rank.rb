class Rank < ActiveRecord::Base
  YEAR        = (1988..(Time.now.year + 1)).to_a.reverse.map(&:to_s)
  RANK_NUMBER = (1..50).to_a.map(&:to_s)

  validates_presence_of :rank_number, :year

  belongs_to :rank_category

  named_scope :ordered, :order => 'year DESC'
end
