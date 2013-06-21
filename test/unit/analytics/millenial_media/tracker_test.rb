require 'test_helper'

module Analytics
  module MillenialMedia
    class TrackerTest < ActiveSupport::TestCase
      context ".track_with_mmurid" do
        setup do
          url = "http://cvt.mydas.mobi/handleConversion?goalid=26148&urid=12345"

          @mm_request = stub_request(:get, url).to_return(:status => 200)
        end

        should "hit the correct URL" do
          Tracker.track_with_mmurid('12345')

          assert_requested(@mm_request)
        end
      end
    end
  end
end
