require File.expand_path('../boot', __FILE__)

require 'rails/all'
#require 'openssl' # required for Geokit TODO remove RF 2-1-16

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bozzuto
  class Application < Rails::Application

    config.autoload_paths += [
      config.root.join('lib'),
      config.root.join('vendor/plugins')
    ]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    config.time_zone = 'Eastern Time (US & Canada)'

    config.i18n.enforce_available_locales = true

    # ----- non standard  TODO remove 2-1-16 RF

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.active_record.raise_in_transactional_callbacks = true
    config.active_record.observers = :apartment_floor_plan_observer

    config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
      RedirectRules.list.each { |rule| r301(*rule) }
    end

    config.middleware.insert_before(Rack::Lock, 'Bozzuto::MissingImages')

    config.middleware.insert_after(ActionDispatch::Session::CookieStore, 'Bozzuto::Mobile::Middleware')

    config.middleware.use('Analytics::MillenialMedia::Middleware')
    config.middleware.use('Analytics::AdSource::Middleware')

    if Rails.env.production?
      config.middleware.use 'Redirectotron'
    end

    config.to_prepare do
      Bozzuto::ExternalFeed::LiveBozzutoFtp.username       = APP_CONFIG.fetch(:ftp, {}).fetch('live_bozzuto', {}).fetch('username', '')
      Bozzuto::ExternalFeed::LiveBozzutoFtp.password       = APP_CONFIG.fetch(:ftp, {}).fetch('live_bozzuto', {}).fetch('password', '')
      Bozzuto::ExternalFeed::QburstFtp.username            = APP_CONFIG.fetch(:ftp, {}).fetch('qburst', {}).fetch('username', '')
      Bozzuto::ExternalFeed::QburstFtp.password            = APP_CONFIG.fetch(:ftp, {}).fetch('qburst', {}).fetch('password', '')
      Bozzuto::ExternalFeed::VaultwareFeed.default_file    = APP_CONFIG[:vaultware_feed_file]
      Bozzuto::ExternalFeed::RentCafeFeed.default_file     = APP_CONFIG[:rent_cafe_feed_file]
      Bozzuto::ExternalFeed::PropertyLinkFeed.default_file = APP_CONFIG[:property_link_feed_file]
      Bozzuto::ExternalFeed::PsiFeed.default_file          = APP_CONFIG[:psi_feed_file]
    end
  end
end
