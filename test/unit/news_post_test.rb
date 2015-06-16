require 'test_helper'

class NewsPostTest < ActiveSupport::TestCase
  context 'NewsPost' do
    should validate_presence_of(:title)
    should validate_presence_of(:body)

    should have_and_belong_to_many(:sections)

    should have_attached_file(:image)
    should have_attached_file(:home_page_image)

    should allow_value(true).for(:show_as_featured_news)
    should allow_value(false).for(:show_as_featured_news)
    should_not allow_value(nil).for(:show_as_featured_news)

    context "with a featured news News Post" do
      before do
        @flagged = NewsPost.make(:show_as_featured_news => true)
      end

      it "only allows one News Post to be flagged as featured news at a time" do
        expect {
          NewsPost.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end

      it "keeps existing featured News Post" do
        expect {
          NewsPost.make(:show_as_featured_news => false)
        }.to_not change {
          @flagged.reload.show_as_featured_news
        }.from(true)
      end
    end

    context "with a non-News Post featured news item" do
      before do
        @flagged = Award.make(:show_as_featured_news => true)
      end

      it "only allows one featured news item -- regardless of class -- at a time" do
        expect {
          NewsPost.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end
    end

    describe "#typus_name" do
      subject { NewsPost.new(:title => 'Hey ya') }

      it "returns the title" do
        subject.typus_name.should == subject.title
      end
    end
  end
end
