# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.17' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'rack-rewrite'
require 'redirectotron'
require 'bozzuto/missing_images'
require 'bozzuto/www_redirector'

Rails::Initializer.run do |config|
  config.autoload_paths << Rails.root.join('app', 'mailers')

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Eastern Time (US & Canada)'

  config.active_record.observers = :apartment_floor_plan_observer

  config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    r301 %r{^/cs/bozzuto_homes/housing_for_all/?},       '/about-us/housing-for-all'
    r301 %r{^/cs/root/corporate/rent_a_home/overview/?}, '/apartments'
    r301 %r{^/cs/root/corporate/homes/?},                '/new-homes'
    r301 %r{^/cs/_corporate/about_us/housing_for_all/?}, '/about-us/housing-for-all'
    r301 %r{^/cs/_corporate/about_us/?},                 '/about-us'
    r301 %r{^/cs/_corporate/acquisitions/?},             '/services/acquisitions'
    r301 %r{^/cs/_corporate/construction/?},             '/services/construction'
    r301 %r{^/cs/root/corporate/development/?},          '/services/development'
    r301 %r{^/cs/bozzuto_homes/?},                       '/services/homebuilding'
    r301 %r{^/cs/land/land_home/?},                      '/services/land'
    r301 %r{^/cs/root/corporate/management/?},           '/services/management'
    r301 %r{^/cs/root/corporate/contact_us/?},           '/about-us/contact'
    r301 %r{^/cs/corporate/aboutus/housing_for_all/?},   '/about-us/housing-for-all'
    r301 %r{^/cs/BozzutoElite/?},                        '/apartments/bozzuto-elite'
    r301 %r{^/cs/BozzutoSmartRent/?},                    '/apartments/smartrent'
    r301 %r{^/cs/root/corporate/rent_a_home/awards/?},   '/about-us/awards'
    r301 %r{^/cs/root/corporate/rent_a_home/news/?},     '/about-us/news'
    r301 %r{^/cs/root/corporate/careers/?},              '/careers'
    r301 %r{^/cs/search_properties/?},                   '/apartments/communities'
    r301 %r{^/property/?},                               '/apartments'
    r301 %r{^/smartrent/?},                              '/apartments/smartrent'
    r301 %r{^/about-us/careers(.*)},                     '/careers$1'
    r301 %r{^/regions/arlington-va-washington-dc/?},     '/regions/arlington-apartments'
    r301 %r{^/regions/bethesda-rockville-apartments/?},  '/regions/bethesda-apartments'
    r301 %r{^/regions/new-york-apartments/?},            '/regions/new-york-city-apartments'
    r301 %r{^/regions/dc-metro-apartments/?},            '/regions/washington-dc-apartments'
    r301 %r{^/regions/dc-nw-apartments/?},               '/regions/washington-dc-apartments'
    r301 %r{^/regions/washington-dc-ne-se-apartments/?}, '/regions/washington-dc-apartments'

    r301 %r{.*},
         'http://www.bozzuto.com/apartments/communities/35-strathmore-court-at-white-flint',
         :if => Proc.new { |rack_env|
           rack_env['SERVER_NAME'] =~ /strathmorecourtapts\.com$/
         }

    r301 %r{.*},
         'http://www.bozzuto.com/apartments/communities/213-timberlawn-crescent',
         :if => Proc.new { |rack_env|
           rack_env['SERVER_NAME'] =~ /timberlawncrescent\.com$/
         }
  end

  if Rails.env.production? || Rails.env.test?
    config.middleware.insert_before(Rack::Lock, Bozzuto::WwwRedirector)
  end

  config.middleware.insert_before(Rack::Lock, Bozzuto::MissingImages)

  if Rails.env.production?
    config.middleware.use Redirectotron
  end
end
