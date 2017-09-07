Bozzuto::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # Rails 4.X Asset-Related Config
  config.assets.digest        = true
  config.assets.js_compressor = :uglifier
  config.assets.compile       = false

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.active_support.deprecation = :log

  config.force_ssl = true

  default_url_options = { host: 'staging.bozzuto.com' }

  config.action_mailer.default_url_options = default_url_options
  Rails.application.default_url_options    = default_url_options

  # Paperclip Config
  config.paperclip_defaults = {
    s3_credentials: {
      bucket:            Rails.application.secrets.s3_bucket,
      access_key_id:     Rails.application.secrets.s3_access_key_id,
      secret_access_key: Rails.application.secrets.s3_secret_access_key
    },
    s3_region:   'us-east-1',
    s3_protocol: 'https'
  }

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!
end
