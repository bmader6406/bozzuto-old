require 'test_helper'

class ProjectCategoryTest < ActiveSupport::TestCase
  context 'ProjectCategory' do
    subject { ProjectCategory.create :title => 'Category title' }

    should have_and_belong_to_many(:projects)

    should validate_presence_of(:title)
    should validate_uniqueness_of(:title)

    describe "#typus_name" do
      it "return the title" do
        subject.typus_name.should == subject.title
      end
    end
  end
end
