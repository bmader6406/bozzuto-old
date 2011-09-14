$: << File.join(File.dirname(__FILE__))

require 'active_support'
require 'net/http'
require 'uri'

require 'extensions/net/http_success'

require 'bossman/base_value_object'
require 'bossman/boss'
require 'bossman/result_set'
require 'bossman/result'
require 'bossman/search'
require 'bossman/oauth'

module BOSSMan
  API_VERSION = :v1
  API_BASEURI = 'http://yboss.yahooapis.com/ysearch'

  attr_accessor :application_id
  module_function :application_id, :application_id=

  attr_accessor :consumer_key
  module_function :consumer_key, :consumer_key=

  attr_accessor :consumer_secret
  module_function :consumer_secret, :consumer_secret=

  class MissingConfiguration < StandardError; end
  class BOSSError < StandardError; end
end
