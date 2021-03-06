Bozzuto::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # Rails 4.X Asset-Related Config
  config.assets.debug                = true
  config.assets.digest               = true
  config.assets.raise_runtime_errors = true

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.active_support.deprecation = :log

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  default_url_options = { host: 'bozzuto.local' }

  config.action_mailer.default_url_options = default_url_options
  Rails.application.default_url_options    = default_url_options

  config.action_mailer.delivery_method = :smtp

  # mocksmtp settings
  config.action_mailer.smtp_settings = {
   :address => 'localhost',
   :port    => 1025,
   :domain  => 'bozzuto.local'
  }

  Resque.inline = true

  # Ensures that models are loaded on every request since cache_classes is false
  # Necessary for functionality relying on included hooks (Bozzuto::Homepage::FeaturableNews)
  config.to_prepare do
    Dir.glob("#{Rails.root}/app/models/*.rb").each do |file|
      File.basename(file, '.rb').camelize.constantize.inspect rescue nil
    end
  end
end
