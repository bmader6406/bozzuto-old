require 'test_helper'

module Bozzuto
  class ExternalFeedLoaderTest < ActiveSupport::TestCase
    context 'An External Feed Loader' do
      setup { @loader = ExternalFeedLoader.new}

      context '#can_load_feed?' do
        context 'the feed is already loading' do
          should 'be false' do
            @loader.expects(:feed_already_loading?).returns(true)

            assert !@loader.can_load_feed?
          end
        end

        context 'the refresh interval has not expired' do
          should 'be false' do
            @loader.expects(:feed_already_loading?).returns(false)
            @loader.expects(:next_load_time).returns(Time.now + 2.hours)

            assert !@loader.can_load_feed?
          end
        end

        context 'the feed can be loaded' do
          should 'be true' do
            @loader.expects(:feed_already_loading?).returns(false)
            @loader.expects(:next_load_time).returns(Time.now - 2.hours)

            assert @loader.can_load_feed?
          end
        end
      end

      context 'temp files' do
        setup do
          @tmp_file  = Rails.root.join('tmp', 'TEST_FEED')
          @lock_file = Rails.root.join('tmp', 'TEST_FEED.lock')

          ExternalFeedLoader.tmp_file  = @tmp_file
          ExternalFeedLoader.lock_file = @lock_file
        end

        teardown do
          ExternalFeedLoader.tmp_file  = nil
          ExternalFeedLoader.lock_file = nil
        end

        context '#touch_tmp_file' do
          should 'touch the tmp file' do
            @loader.expects(:system).with("touch #{@tmp_file}")
            @loader.send(:touch_tmp_file)
          end
        end

        context '#touch_lock_file' do
          should 'touch the lock file' do
            @loader.expects(:system).with("touch #{@lock_file}")
            @loader.send(:touch_lock_file)
          end
        end

        context '#rm_lock_file' do
          should 'rm the lock file' do
            @loader.expects(:system).with("rm #{@lock_file}")
            @loader.send(:rm_lock_file)
          end
        end
      end
    end

    context 'The External Feed Loader class' do
      context '#loader_for_type' do
        context 'vaultware' do
          should 'return an instance of VaultwareFeedLoader' do
            loader = ExternalFeedLoader.loader_for_type('vaultware')
            assert loader.is_a?(VaultwareFeedLoader)
          end
        end

        context 'property_link' do
          should 'return an instance of PropertyLinkFeedLoader' do
            loader = ExternalFeedLoader.loader_for_type('property_link')
            assert loader.is_a?(PropertyLinkFeedLoader)
          end
        end

        context 'unknown feed' do
          should 'raise an exception' do
            assert_raises(RuntimeError) do
              ExternalFeedLoader.loader_for_type('batman')
            end
          end
        end
      end
    end
  end
end
