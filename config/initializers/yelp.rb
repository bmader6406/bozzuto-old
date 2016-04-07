require 'yelp'

YELP_CONFIG = APP_CONFIG[:yelp].with_indifferent_access

unless Rails.env.test?
  Yelp.client.configure do |config|
    config.consumer_key    = YELP_CONFIG[:consumer_key]
    config.consumer_secret = YELP_CONFIG[:consumer_secret]
    config.token           = YELP_CONFIG[:token]
    config.token_secret    = YELP_CONFIG[:token_secret]
  end
end
