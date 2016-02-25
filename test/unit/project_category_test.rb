require 'test_helper'

class ProjectCategoryTest < ActiveSupport::TestCase
  context 'ProjectCategory' do
    subject { ProjectCategory.create :title => 'Category title' }

    should have_and_belong_to_many(:projects)

    should validate_presence_of(:title)
    should validate_uniqueness_of(:title)

    describe "#to_s" do
      it "return the title" do
        subject.to_s.should == subject.title
      end
    end

    describe "#to_label" do
      it "return the title" do
        subject.to_label.should == subject.title
      end
    end
  end
end
