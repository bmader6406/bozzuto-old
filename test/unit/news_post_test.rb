require 'test_helper'

class NewsPostTest < ActiveSupport::TestCase
  extend SharedFeaturableNewsTests

  context 'NewsPost' do

    should have_and_belong_to_many(:sections)

    should validate_presence_of(:title)
    should validate_presence_of(:body)

    it_should_behave_like "a featurable news item", NewsPost

    describe "#to_s" do
      subject { NewsPost.new(:title => 'Hey ya') }

      it "returns the title" do
        subject.to_s.should == subject.title
      end
    end

    describe "#to_label" do
      subject { NewsPost.new(:title => 'Hey ya') }

      it "returns the title" do
        subject.to_label.should == subject.title
      end
    end
  end
end
