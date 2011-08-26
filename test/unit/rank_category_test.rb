require 'test_helper'

class RankCategoryTest < ActiveSupport::TestCase
  context 'A RankCategory' do
    setup { @category = RankCategory.new }

    should_validate_presence_of :name

    should_belong_to :publication
  end
end
