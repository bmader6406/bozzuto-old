Bozzuto::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.action_controller.perform_caching = true
  config.consider_all_requests_local       = false

  config.active_support.deprecation = :log

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

  config.action_controller.asset_host = proc { |source, request|
    protocol = request ? request.protocol : 'http://'

    "#{protocol}www.bozzuto.com"
  }

  config.action_mailer.default_url_options = {
    :host => 'bozzuto.com'
  }

  #config.action_mailer.smtp_settings = {
  #  :address              => 'mail.bozzuto.com',
  #  :domain               => 'bozzuto.com',
  #  :port                 => 25,
  #  :user_name            => 'inquiries',
  #  :password             => 'Bozzuto22',
  #  :authentication       => :login,
  #  :enable_starttls_auto => false
  #}

  config.action_mailer.smtp_settings = {
    :address              => 'smtp.gmail.com',
    :domain               => 'vigetlabs.com',
    :port                 => 587,
    :user_name            => 'bozzutoinquiries@vigetlabs.com',
    :password             => 'SbR2bZ>D',
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
end
