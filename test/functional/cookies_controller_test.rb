require 'test_helper'

class CookieControllerTest < ActionDispatch::IntegrationTest
  context "CookieController" do
    describe "GET #enable" do
      before do
        cookies[CookiesController::DISABLE_COOKIES_FIELD] = CookiesController::COOKIES_ENABLED
      end

      it "deletes the cookie that disables cookies" do
        get '/cookies/enable'

        response.status.should == 200

        cookies[CookiesController::DISABLE_COOKIES_FIELD].should == CookiesController::COOKIES_ENABLED
      end
    end

=begin
    TODO Temporarily disabled route in config/routes.rb, so commenting the corresponding test.
    describe "GET #disable" do
      it "adds a permanent cookie to disable cookies" do
        get '/cookies/disable'

        response.status.should == 200

        cookies[CookiesController::DISABLE_COOKIES_FIELD].should == CookiesController::COOKIES_DISABLED
      end
    end
=end
  end
end
