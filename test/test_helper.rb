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
end
