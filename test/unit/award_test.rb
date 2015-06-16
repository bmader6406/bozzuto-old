require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  context 'Award' do
    should validate_presence_of(:title)

    should have_and_belong_to_many(:sections)

    should have_attached_file(:image)

    should allow_value(true).for(:show_as_featured_news)
    should allow_value(false).for(:show_as_featured_news)
    should_not allow_value(nil).for(:show_as_featured_news)

    context "with a featured news Award" do
      before do
        @flagged = Award.make(:show_as_featured_news => true)
      end

      it "only allows one Award to be flagged as featured news at a time" do
        expect {
          Award.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end

      it "keeps existing featured Award" do
        expect {
          Award.make(:show_as_featured_news => false)
        }.to_not change {
          @flagged.reload.show_as_featured_news
        }.from(true)
      end
    end

    context "with a non-Award featured news item" do
      before do
        @flagged = NewsPost.make(:show_as_featured_news => true)
      end

      it "only allows one featured news item -- regardless of class -- at a time" do
        expect {
          Award.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end
    end

    context '#typus_name' do
      setup { @award = Award.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @award.title, @award.typus_name
      end
    end
  end
end
