require 'test_helper'

module Analytics
  module MillenialMedia
    class TrackerTest < ActiveSupport::TestCase
      context ".track_with_uid" do
        setup do
          url = "http://cvt.mydas.mobi/handleConversion?goalid=26148&urid=12345"

          stub_request(:get, url).to_return(:status => 200)
        end

        should "hit the correct URL" do
          #Tracker.track_with_urid('12345')
        end
      end
    end
  end
end
