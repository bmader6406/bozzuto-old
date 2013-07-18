ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'

require File.join(Rails.root, 'test', 'blueprints')
require File.join(Rails.root, 'vendor', 'plugins', 'typus', 'lib', 'extensions', 'object')

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
end

class ActiveSupport::TestCase
  include WebMock::API

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

    super
  end

  def rm_feed_loader_tmp_files
    Bozzuto::ExternalFeedLoader.feed_types.each do |type|
      loader = Bozzuto::ExternalFeedLoader.loader_for_type(type)

      `rm #{loader.class.tmp_file}` if File.exists?(loader.class.tmp_file)
      `rm #{loader.class.lock_file}` if File.exists?(loader.class.lock_file)
    end
  end

  def set_mobile!
    @request.format = :mobile
    @request.env['bozzuto.mobile.device'] = :iphone
  end

  class << self
    def should_redirect_to_home_page
      should_respond_with :redirect
      should_redirect_to('the home page') { root_path }
    end

    def mobile_context(&block)
      context 'from a mobile device' do
        setup do
          set_mobile!
        end

        context(nil, &block)
      end
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
