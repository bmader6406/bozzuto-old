require 'test_helper'

class MillenialMediaMiddlewareTest < ActionController::IntegrationTest
  context "A request" do
    context "with the mmurid param present" do
      setup do
        @community = ApartmentCommunity.make

        url = "http://cvt.mydas.mobi/handleConversion?goalid=26148&urid=hooray"

        @mm_request = stub_request(:get, url).to_return(:status => 200)
      end

      should "ping the MillenialMedia URL" do
        get '/', :mmurid => 'hooray'
        get "/apartments/communities/#{@community.to_param}/contact/thank_you"

        assert_requested(@mm_request)
      end
    end
  end
end
