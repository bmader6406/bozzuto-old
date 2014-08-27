# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.17' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'rack-rewrite'
require 'redirectotron'
require 'redirect_rules'
require 'bozzuto/missing_images'
require 'bozzuto/mobile/middleware'
require 'analytics/millenial_media/middleware'
require 'analytics/ad_source/middleware'

Rails::Initializer.run do |config|
  config.autoload_paths << Rails.root.join('app', 'mailers')

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Eastern Time (US & Canada)'

  config.active_record.observers = :apartment_floor_plan_observer

  config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    RedirectRules.list.each { |rule| r301 *rule }
  end

  config.middleware.insert_before(Rack::Lock, Bozzuto::MissingImages)

  config.middleware.insert_after(ActionController::Session::CookieStore, Bozzuto::Mobile::Middleware)

  config.middleware.use(Analytics::MillenialMedia::Middleware)
  config.middleware.use('Analytics::AdSource::Middleware')

  if Rails.env.production?
    config.middleware.use Redirectotron
  end

  config.to_prepare do
    Bozzuto::ExternalFeed::InboundFtp.username           = APP_CONFIG.fetch(:ftp, {}).fetch('inbound', {}).fetch('username', '')
    Bozzuto::ExternalFeed::InboundFtp.password           = APP_CONFIG.fetch(:ftp, {}).fetch('inbound', {}).fetch('password', '')
    Bozzuto::ExternalFeed::OutboundFtp.username          = APP_CONFIG.fetch(:ftp, {}).fetch('outbound', {}).fetch('username', '')
    Bozzuto::ExternalFeed::OutboundFtp.password          = APP_CONFIG.fetch(:ftp, {}).fetch('outbound', {}).fetch('password', '')
    Bozzuto::ExternalFeed::VaultwareFeed.default_file    = APP_CONFIG[:vaultware_feed_file]
    Bozzuto::ExternalFeed::RentCafeFeed.default_file     = APP_CONFIG[:rent_cafe_feed_file]
    Bozzuto::ExternalFeed::PropertyLinkFeed.default_file = APP_CONFIG[:property_link_feed_file]
    Bozzuto::ExternalFeed::PsiFeed.default_file          = APP_CONFIG[:psi_feed_file]
  end
end
