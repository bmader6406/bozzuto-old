require 'test_helper'

class NewsPostTest < ActiveSupport::TestCase
  extend SharedFeaturableNewsTests

  context 'NewsPost' do
    should validate_presence_of(:title)
    should validate_presence_of(:body)

    should have_and_belong_to_many(:sections)

    should have_attached_file(:image)
    should have_attached_file(:home_page_image)

    it_should_behave_like "a featurable news item", NewsPost

    describe "#typus_name" do
      subject { NewsPost.new(:title => 'Hey ya') }

      it "returns the title" do
        subject.typus_name.should == subject.title
      end
    end
  end
end
