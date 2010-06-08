require 'test_helper'

class YelpFeedTest < ActiveSupport::TestCase
  context 'A YelpFeed' do
    setup do
      @feed = YelpFeed.make
    end

    subject { @feed }

    should_have_many :items, :dependent => :destroy

    should_validate_presence_of :url
    should_validate_uniqueness_of :url
  end
end
