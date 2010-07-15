require 'test_helper'

class ProjectCategoryTest < ActiveSupport::TestCase
  context 'ProjectCategory' do
    setup do
      @category = ProjectCategory.create :title => 'Category title'
    end

    subject { @category }

    should_have_and_belong_to_many :projects

    should_validate_presence_of :title
    should_validate_uniqueness_of :title

    context '#typus_name' do
      should 'return the title' do
        assert_equal @category.title, @category.typus_name
      end
    end
  end
end
