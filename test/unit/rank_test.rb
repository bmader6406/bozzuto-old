require 'test_helper'

class RankTest < ActiveSupport::TestCase
  subject { Rank.new }

  should belong_to(:rank_category)

  should validate_presence_of(:rank_number)
  should validate_presence_of(:year)

  should validate_numericality_of(:rank_number)
end
