require 'test_helper'

class RankTest < ActiveSupport::TestCase
  setup { @rank = Rank.new }

  should_validate_presence_of :rank_number, :year

  should_validate_numericality_of :rank_number

  should_belong_to :rank_category
end
