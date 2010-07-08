ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require File.expand_path(File.dirname(__FILE__) + "/blueprints")

class ActiveSupport::TestCase
  include WebMock

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def load_fixture_file(file)
    File.read("#{RAILS_ROOT}/test/fixtures/#{file}")
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

  setup do
    ApartmentFloorPlanGroup.create :name => 'Studio'
    ApartmentFloorPlanGroup.create :name => '1 Bedroom'
    ApartmentFloorPlanGroup.create :name => '2 Bedrooms'
    ApartmentFloorPlanGroup.create :name => '3 or More Bedrooms'
    ApartmentFloorPlanGroup.create :name => 'Penthouse'
  end
end
