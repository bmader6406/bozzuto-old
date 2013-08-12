require 'test_helper'

module Analytics
  class AdSourceTest < ActionController::IntegrationTest
    AD_SOURCE_COOKIE = Analytics::AdSource::Middleware::RequestProcessor::AD_SOURCE_COOKIE

    def self.should_set_lead_channel(value)
      should "set the lead channel value to '#{value}'" do
        assert_lead_channel(value)
      end
    end

    def self.should_set_dnr(value)
      should "set the DNR value to '#{value}'" do
        assert_dnr(value)
      end
    end

    def self.should_set_ad_source_cookie(value)
      should "set the ad source cookie" do
        assert_ad_source_cookie(value)
      end
    end

    context "A request" do
      context "ad source cookie is present" do
        setup do
          get '/', nil, { :cookie => "#{AD_SOURCE_COOKIE}=Batman; path=/; expires=#{30.days.from_now}" }
        end

        should_set_lead_channel('Batman')
        should_set_dnr('Batman')
      end

      context "ad source param is present" do
        setup do
          get '/', 'ctx_Ad Source' => 'Two-Face'
        end

        should_set_lead_channel('Two-Face')
        should_set_dnr('Two-Face')
        should_set_ad_source_cookie('Two-Face')
      end

      context "referrer matches" do
        setup do
          @referrer = ::AdSource.make(:domain_name => 'apartments.com', :value => 'Apartments')

          get '/', nil, { :referer => 'http://apartments.com' }
        end

        should_set_lead_channel('Apartments')
        should_set_dnr('Apartments')
        should_set_ad_source_cookie('Apartments')
      end

      context "all other requests" do
        context "request is from a mobile device" do
          setup do
            get '/', nil, { :user_agent => "iPhone" }
          end

          should_set_lead_channel('Bozzuto.comMobile')
          should_set_dnr(nil)
        end

        context "request is not from a mobile device" do
          setup do
            get '/'
          end

          should_set_lead_channel('Bozzuto.com')
          should_set_dnr(nil)
        end
      end
    end


    def env
      @request.env
    end

    def assert_lead_channel(value)
      assert_equal value, env['bozzuto.ad_source.lead_channel']
    end

    def assert_dnr(value)
      assert_equal value, env['bozzuto.ad_source.dnr']
    end

    def assert_cookie(name, value)
      assert_equal value, cookies[name]
    end

    def assert_cookie_expiration(name, time)
      assert((full_cookies[name]['expires'] - time).abs < 20)
    end

    def assert_ad_source_cookie(value)
      assert_cookie(AD_SOURCE_COOKIE, value)
      assert_cookie_expiration(AD_SOURCE_COOKIE, 30.days.from_now)
    end
  end
end
