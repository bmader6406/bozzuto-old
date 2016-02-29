require 'test_helper'

class RankCategoryTest < ActiveSupport::TestCase
  context 'A RankCategory' do
    subject { RankCategory.new }

    should belong_to(:publication)

    should have_many(:ranks)

    should validate_presence_of(:name)
    should validate_presence_of(:publication)
  end
end
