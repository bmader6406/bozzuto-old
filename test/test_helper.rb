ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'

require File.join(Rails.root, 'test', 'blueprints')
require File.join(Rails.root, 'vendor', 'plugins', 'typus', 'lib', 'extensions', 'object')

class ActiveSupport::TestCase
  include WebMock

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def load_fixture_file(file)
    File.read("#{Rails.root}/test/files/#{file}")
  end

  def create_states
    State.create([{ :code => 'CT', :name => 'Connecticut' },
                  { :code => 'MD', :name => 'Maryland' },
                  { :code => 'MA', :name => 'Massachusetts' },
                  { :code => 'NJ', :name => 'New Jersey' },
                  { :code => 'NY', :name => 'New York' },
                  { :code => 'PA', :name => 'Pennsylvania' },
                  { :code => 'VA', :name => 'Virginia' },
                  { :code => 'DC', :name => 'Washington, DC' }])
  end

  def setup
    ApartmentFloorPlanGroup.create :name => 'Studio'
    ApartmentFloorPlanGroup.create :name => '1 Bedroom'
    ApartmentFloorPlanGroup.create :name => '2 Bedrooms'
    ApartmentFloorPlanGroup.create :name => '3 or More Bedrooms'
    ApartmentFloorPlanGroup.create :name => 'Penthouse'

    stub_request(:get, 'https://api.twitter.com/1/users/show.json?screen_name=TheBozzutoGroup').to_return(
      :body => load_fixture_file('twitter_user.json')
    )

    stub_request(:get, 'https://api.twitter.com/1/statuses/user_timeline.json?screen_name=TheBozzutoGroup').to_return(
      :body => load_fixture_file('twitter_user_timeline.json')
    )

    super
  end

  def set_mobile_user_agent!
    @request.env['HTTP_USER_AGENT'] = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_2_1 like Mac OS X; da-dk) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5'
  end

  class << self
    def mobile_context(&block)
      context('from a mobile device', &block)
    end

    def browser_context(&block)
      context('from a web browser', &block)
    end
  end
end

class ActionController::TestCase
  protected
  
  def login_typus_user(user)
    session[:typus_user_id] = user.id
  end
end
