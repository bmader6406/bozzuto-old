require 'test_helper'

class RankCategoryTest < ActiveSupport::TestCase
  context 'A RankCategory' do
    subject { RankCategory.new }

    should validate_presence_of(:name)

    should belong_to(:publication)
  end
end
