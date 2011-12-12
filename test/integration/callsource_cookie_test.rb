require 'test_helper'

class CallsourceCookieTest < ActionController::IntegrationTest
  COOKIE = Callsource::Referrer::DNR_COOKIE

  def assert_dnr_cookie(value)
    assert_equal value, cookies[COOKIE]
  end

  def self.should_not_set_the_dnr_cookie
    should 'not set the DNR cookie' do
      assert_nil cookies[COOKIE]
    end
  end

  def self.should_set_the_cookie_expiration
    should 'set the expiration date' do
      assert (full_cookies[COOKIE]['expires'] - 30.days.from_now).abs < 20
    end
  end


  context 'A request' do
    setup { @dnr = DnrReferrer.make(:domain_name => 'apartments.com') }

    context 'without a referrer' do
      setup { get '/' }

      should_not_set_the_dnr_cookie
    end

    context 'with a referrer that does not match' do
      setup do
        get '/', nil, { :referer => 'http://nytimes.com' }
      end

      should_not_set_the_dnr_cookie
    end

    context 'with a referrer that matches' do
      setup do
        get '/', nil, { :referer => 'http://apartments.com' }
      end

      should 'set the DNR cookie' do
        assert_dnr_cookie 'apartments.com'
      end

      should_set_the_cookie_expiration
    end

    context 'with a referrer that was set 15 days ago' do
      setup do
        get '/', nil, { :cookie => "#{COOKIE}=apple.com; path=/; expires=#{15.days.ago}" }
      end

      should 'set the same referrer that was already in the cookie' do
        assert_dnr_cookie 'apple.com'
      end

      should_set_the_cookie_expiration
    end

    context 'with a referrer already saved and a new one coming in that does not match' do
      setup do
        get '/', nil, {
          :cookie  => "#{COOKIE}=apple.com; path=/; expires=#{15.days.ago}",
          :referer => 'nomatch.com'
        }
      end

      should 'set the same referrer that was already in the cookie' do
        assert_dnr_cookie 'apple.com'
      end

      should_set_the_cookie_expiration
    end

    context 'with a referrer already saved and a new one coming in that matches' do
      setup do
        get '/', nil, {
          :cookie  => "#{COOKIE}=apple.com; path=/; expires=#{15.days.ago}",
          :referer => 'http://apartments.com'
        }
      end

      should 'set the cookie to the new referrer' do
        assert_dnr_cookie 'apartments.com'
      end

      should_set_the_cookie_expiration
    end
  end


  # Helper method to get path and expires data from the Set-Cookie header
  def full_cookies
    HashWithIndifferentAccess.new.tap do |hash|
      @response.headers['Set-Cookie'].dup.each do |cookie|
        key = nil

        details = cookie.split(';').inject(HashWithIndifferentAccess.new) do |fields, cookie_field|
          pair = cookie_field.split('=').map { |val|
            Rack::Utils.unescape(val.strip)
          }

          key = pair.first unless key

          fields.merge(pair.first => pair.last)
        end

        if details['expires']
          details['expires'] = Time.parse(details['expires'])
        end

        hash[key] = details
      end
    end
  end
end
