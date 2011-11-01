require 'test_helper'

class MissingImagesMiddlewareTest < ActionController::IntegrationTest
  def self.should_respond_with(code)
    should "have response code #{code}" do
      assert_equal code, @response.code.to_i
    end
  end

  context 'A request' do
    context 'to an image' do
      setup { get '/yay/hooray.jpg' }

      should_respond_with 404
    end

    context 'to non-image content' do
      setup { get '/' }

      should_respond_with 200
    end
  end
end
