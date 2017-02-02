ENV['RAILS_ENV'] ||= 'test'

if ENV['COV']
  require 'simplecov'

  SimpleCov.minimum_coverage 100

  SimpleCov.start 'rails' do
    add_filter '/app/admin'
    add_filter '/vendor'
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'shoulda'
require 'shoulda_macros/paperclip'
require 'paperclip/matchers'
require 'webmock/minitest'
require 'mocha/mini_test'

require Rails.root.join('test', 'support', 'shared_examples')
require Rails.root.join('test', 'blueprints')

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

DatabaseCleaner.clean_with :deletion
DatabaseCleaner.strategy = :truncation

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :allow_playback_repeats =>  true }
  # c.debug_logger = $stderr

  c.register_request_matcher :algolia_path_matcher do |request_1, request_2|
    path1 = URI(request_1.uri).path.match(/\/\d+\/indexes\/bozzutosite_test\/(.+)\z/)[1].gsub(/\/?\d+\z/, '')
    path2 = URI(request_2.uri).path.match(/\/\d+\/indexes\/bozzutosite_test\/(.+)\z/)[1].gsub(/\/?\d+\z/, '')

    path1 == path2 ||
      (AlgoliaSearch::Utilities.get_model_classes.map(&:name).include?(path1) &&
      AlgoliaSearch::Utilities.get_model_classes.map(&:name).include?(path2))
  end

  c.register_request_matcher :algolia_host_matcher do |request_1, request_2|
    URI(request_1.uri).host =~ /algolia(net\.com|\.net)\z/ && 
      URI(request_2.uri).host =~ /algolia(net\.com|\.net)\z/
  end
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

  class << self
    def uses_transaction?(method)
      method.to_s.include?("without transactions")
    end
  end
end

class ActionController::TestCase
  include RSpec::Matchers
  include Bozzuto::Test::ControllerExtensions
  include Devise::TestHelpers
end

class ActionDispatch::IntegrationTest
  include Bozzuto::Test::IntegrationExtensions
end
