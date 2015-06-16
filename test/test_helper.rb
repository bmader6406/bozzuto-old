ENV["RAILS_ENV"] = "test"

if ENV['COV']
  require 'simplecov'

  SimpleCov.minimum_coverage 100

  SimpleCov.start 'rails' do
    add_filter '/app/controllers/admin'
    add_filter '/app/helpers/admin_helper'
    add_filter '/app/models/asset'
    add_filter '/app/models/picture'
    add_filter '/lib/typus'
    add_filter '/vendor'
  end
end

require 'shoulda'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'shoulda/rails'
require 'rails/test_help'
require 'mocha'
require 'rspec/expectations'
require 'shoulda_macros/paperclip'

require Rails.root.join('test', 'support', 'shared_examples')
require Rails.root.join('test', 'blueprints')
require Rails.root.join('vendor', 'plugins', 'typus', 'lib', 'extensions', 'object')

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
end


class Shoulda::Context
  alias_method :describe, :context
  alias_method :before,   :setup
  alias_method :after,    :teardown
  alias_method :it,       :should
end


class ActiveSupport::TestCase
  include WebMock::API
  extend  Paperclip::Shoulda
  include Bozzuto::Test::Extensions
  include Bozzuto::Test::ModelExtensions
  extend  SharedExamples

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

class ActionController::TestCase
  include Bozzuto::Test::ControllerExtensions
end

class ActionController::IntegrationTest
  include Bozzuto::Test::IntegrationExtensions
end
