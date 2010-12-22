require 'test_helper'

class DetectMobileUserAgentTest < ActionController::IntegrationTest
  context 'A request' do
    context 'without a mobile user agent' do
      setup do
        get '/'
      end

      should 'not set the request format to mobile' do
        assert_equal :html, @request.format.to_sym
      end
    end

    context 'with a mobile user agent' do
      setup do
        get '/', nil, :user_agent => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; da-dk) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5'
      end

      should 'set the request format to mobile' do
        assert_equal :mobile, @request.format.to_sym
      end
    end
  end
end
