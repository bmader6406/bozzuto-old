require 'test_helper'

class CookieControllerTest < ActionDispatch::IntegrationTest
  context "CookieController" do
    describe "GET #enable" do
      before do
        cookies[CookiesController::DISABLE_COOKIES] = true
      end

      it "deletes the cookie that disables cookies" do
        get '/cookies/enable'

        response.status.should == 200

        cookies[CookiesController::DISABLE_COOKIES].should_not be_present
      end
    end

    describe "GET #disable" do
      it "adds a permanent cookie to disable cookies" do
        get '/cookies/disable'

        response.status.should == 200

        cookies[CookiesController::DISABLE_COOKIES].should be_present
      end
    end
  end
end
