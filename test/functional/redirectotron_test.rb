require 'test_helper'

class RedirectotronTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rack::Builder.app do
      use Redirectotron

      run lambda { |env|
        if env['PATH_INFO'] == '/found'
          [200, {}, ["Yay"]]
        else
          [404, {}, ["D'oh"]]
        end
      }
    end
  end

  context 'a reponse that is not 404' do
    setup { get '/found' }

    should 'not alter the response' do
      assert_equal 200, last_response.status
      assert_equal 'Yay', last_response.body
    end
  end

  context 'a 404 response' do
    setup { get '/not_found' }

    should 'be rewritten to a 301 redirect' do
      assert_equal 301, last_response.status
      assert_equal 'Redirect', last_response.body
    end

    should 'redirect to the home page' do
      assert_equal '/', last_response.headers['Location']
    end
  end
end
