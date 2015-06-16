require 'test_helper'

class PressReleaseTest < ActiveSupport::TestCase
  context 'A press release' do
    should validate_presence_of(:title)
    should validate_presence_of(:body)

    should have_and_belong_to_many(:sections)

    should allow_value(true).for(:show_as_featured_news)
    should allow_value(false).for(:show_as_featured_news)
    should_not allow_value(nil).for(:show_as_featured_news)

    context "with a featured news Press Release" do
      before do
        @flagged = PressRelease.make(:show_as_featured_news => true)
      end

      it "only allows one Press Release to be flagged as featured news at a time" do
        expect {
          PressRelease.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end

      it "keeps existing featured Press Release" do
        expect {
          PressRelease.make(:show_as_featured_news => false)
        }.to_not change {
          @flagged.reload.show_as_featured_news
        }.from(true)
      end
    end

    context "with a non-Press Release featured news item" do
      before do
        @flagged = NewsPost.make(:show_as_featured_news => true)
      end

      it "only allows one featured news item -- regardless of class -- at a time" do
        expect {
          PressRelease.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end
    end

    context '#typus_name' do
      setup { @press = PressRelease.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @press.title, @press.typus_name
      end
    end
  end
end
