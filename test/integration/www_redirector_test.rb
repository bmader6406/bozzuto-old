require 'test_helper'

class WwwRedirectorTest < ActionController::IntegrationTest
  def self.should_respond_with(code)
    should "have response code #{code}" do
      assert_equal code, @response.code.to_i
    end
  end

  context 'A request' do
    context 'using bozzuto.com' do
      setup do
        get '/apartments/communities', nil, { :host => 'bozzuto.com' }
      end

      should_respond_with 301

      should 'redirect to the full path' do
        assert_equal 'http://www.bozzuto.com/apartments/communities', @response.headers['Location']
      end
    end

    context 'using www.bozzuto.com' do
      setup do
        get '/apartments/communities', nil, { :host => 'www.bozzuto.com' }
      end

      should_respond_with 200
    end
  end
end
