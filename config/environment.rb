# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'rack-rewrite'
require 'redirectotron'

Rails::Initializer.run do |config|
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Eastern Time (US & Canada)'

  config.active_record.observers = :apartment_floor_plan_observer

  config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    r301 %r{^/cs/bozzuto_homes/housing_for_all/?}, '/about-us/housing-for-all'
    r301 %r{^/cs/root/corporate/rent_a_home/overview/?}, '/apartments'
    r301 %r{^/cs/root/corporate/homes/?}, '/new-homes'
    r301 %r{^/cs/_corporate/about_us/housing_for_all/?}, '/about-us/housing-for-all'
    r301 %r{^/cs/_corporate/about_us/?}, '/about-us'
    r301 %r{^/cs/_corporate/acquisitions/?}, '/services/acquisitions'
    r301 %r{^/cs/_corporate/construction/?}, '/services/construction'
    r301 %r{^/cs/root/corporate/development/?}, '/services/development'
    r301 %r{^/cs/bozzuto_homes/?}, '/services/homebuilding'
    r301 %r{^/cs/land/land_home/?}, '/services/land'
    r301 %r{^/cs/root/corporate/management/?}, '/services/management'
    r301 %r{^/cs/root/corporate/contact_us/?}, '/about-us/contact'
    r301 %r{^/cs/corporate/aboutus/housing_for_all/?}, '/about-us/housing-for-all'
    r301 %r{^/cs/BozzutoElite/?}, '/apartments/bozzuto-elite'
    r301 %r{^/cs/BozzutoSmartRent/?}, '/apartments/smartrent'
    r301 %r{^/cs/root/corporate/rent_a_home/awards/?}, '/about-us/awards'
    r301 %r{^/cs/root/corporate/rent_a_home/news/?}, '/about-us/news'
    r301 %r{^/cs/root/corporate/careers/?}, '/about-us/careers'
    r301 %r{^/cs/search_properties/?}, '/apartments/communities'
    r301 %r{^/property/?}, '/apartments'
    r301 %r{^/smartrent/?}, '/apartments/smartrent'
  end

  config.middleware.use Redirectotron if Rails.env.production?
end

ActionView::Base.default_form_builder = Bozzuto::FormBuilder
