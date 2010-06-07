require 'test_helper'

class RecentQueueTest < ActiveSupport::TestCase
  context "A recent queue" do
    setup do
      @queue = RecentQueue.new
    end

    should "be empty by default" do
      assert @queue.empty?
    end

    should "not push the same object on twice" do
      property = "i am a property"
      @queue.push(property)
      @queue << property

      assert_equal 1, @queue.length
    end

    should "not hold more than 8 items" do
      @queue.max_length = 8
      8.times do |i|
        @queue << i
      end

      assert_no_difference("@queue.length") do
        @queue << "property"
      end
    end
  end
end
