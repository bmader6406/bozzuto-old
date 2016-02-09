ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

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
require 'shoulda_macros/paperclip'
require 'paperclip/matchers'
require 'webmock/minitest'
require 'mocha/mini_test'

require Rails.root.join('vendor', 'plugins', 'typus', 'lib', 'extensions', 'object')
require Rails.root.join('test', 'support', 'shared_examples')
require Rails.root.join('test', 'blueprints')

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
end

RSpec::Matchers.configuration.syntax = %i(should expect)

class Shoulda::Context::Context
  alias_method :describe, :context
  alias_method :before,   :setup
  alias_method :after,    :teardown
  alias_method :it,       :should
end

class ActiveSupport::TestCase
  extend SharedExamples

  include RSpec::Matchers
  include Bozzuto::Test::Extensions
  include Bozzuto::Test::ModelExtensions
end

class ActionController::TestCase
  include RSpec::Matchers
  include Bozzuto::Test::ControllerExtensions
end

class ActionDispatch::IntegrationTest
  include Bozzuto::Test::IntegrationExtensions
end
