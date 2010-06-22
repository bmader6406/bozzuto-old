require 'test_helper'

class RecentQueueTest < ActiveSupport::TestCase
  context "A recent queue" do
    setup do
      @queue = RecentQueue.new
    end

    context 'class accessors' do
      setup do
        @queue = [1, 2, 3]
        Thread.current[:queue] = @queue
      end

      teardown { Thread.current[:queue] = nil }

      context '#current_queue' do
        should 'return the data in Thread.current[:queue]' do
          assert_equal @queue, RecentQueue.current_queue
        end
      end

      context '#current_queue=' do
        setup do
          @new_queue = [4, 5, 6]
          RecentQueue.current_queue = @new_queue
        end

        should 'assign the queue to Thread.current[:queue]' do
          assert_equal @new_queue, Thread.current[:queue]
        end
      end

      context '#find' do
        setup do
          @recent_queue = RecentQueue.find
        end

        should 'return a new RecentQueue with the current queue data' do
          assert_equal @queue, @recent_queue.to_a
        end
      end
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
