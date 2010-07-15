require 'test_helper'

class ProjectCategoryTest < ActiveSupport::TestCase
  context 'ProjectCategory' do
    setup do
      @category = ProjectCategory.create :title => 'Category title'
    end

    subject { @category }

    should_validate_presence_of :title
    should_validate_uniqueness_of :title
  end
end
