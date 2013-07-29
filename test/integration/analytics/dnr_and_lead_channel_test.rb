require 'test_helper'

module Analytics
  class DnrAndLeadChannelTest < ActionController::IntegrationTest
    SEARCH_ENGINES       = ['google.com', 'yahoo.com', 'bing.com']
    CTX_AD_SOURCE_COOKIE = Analytics::DnrAndLeadChannel::RequestProcessor::CTX_AD_SOURCE_COOKIE
    UTM_SOURCE_COOKIE    = Analytics::DnrAndLeadChannel::RequestProcessor::UTM_SOURCE_COOKIE

    context "A request" do
      context "referred by a search engine" do
        SEARCH_ENGINES.each do |engine|
          context(engine) do
            context "tsa params are present" do
              setup do
                get '/',
                    { 'ctx_Ad Source' => 'yay', 'utm_source' => 'hooray' },
                    { :referer => "http://#{engine}" }
              end

              should "set the lead channel value to the combined param" do
                assert_lead_channel('yay-hooray')
              end

              should "set the DNR value to utm_source" do
                assert_dnr('hooray')
              end

              should "set the ctx_ad_source cookie" do
                assert_ctx_ad_source_cookie('yay')
              end

              should "set the utm_source cookie" do
                assert_utm_source_cookie('hooray')
              end
            end

            context "ctx_ad_source param isn't present" do
              setup do
                get '/',
                    { 'utm_source' => 'hooray' },
                    { :referer => "http://#{engine}" }
              end

              should "set the lead channel value to the referrer domain" do
                assert_lead_channel(engine)
              end

              should "set the DNR value to the referrer domain" do
                assert_dnr(engine)
              end
            end
          end
        end
      end

      context "with cookies saved" do
        setup do
          get '/', nil, {
            :cookie => [
              "#{CTX_AD_SOURCE_COOKIE}=I'm; path=/; expires=#{30.days.from_now}",
              "#{UTM_SOURCE_COOKIE}=Batman; path=/; expires=#{30.days.from_now}"
            ].join(',')
          }
        end

        should "set the lead channel value to the combined cookie value" do
          assert_lead_channel("I'm-Batman")
        end

        should "set the DNR value to the utm source cookie" do
          assert_dnr('Batman')
        end
      end

      context "any other request" do
        context "request is mobile" do
          setup do
            get '/', nil, { :user_agent => "iPhone" }
          end

          should "set the lead channel value to 'Bozzuto.comMobile'" do
            assert_lead_channel('Bozzuto.comMobile')
          end

          should "set the DNR value to nil" do
            assert_dnr(nil)
          end
        end

        context "request is not mobile" do
          setup do
            get '/'
          end

          should "set the lead channel value to 'Bozzuto.com'" do
            assert_lead_channel('Bozzuto.com')
          end

          should "set the DNR value to nil" do
            assert_dnr(nil)
          end
        end
      end
    end

    def env
      @request.env
    end

    def assert_lead_channel(value)
      assert_equal value, env['bozzuto.lead_channel']
    end

    def assert_dnr(value)
      assert_equal value, env['bozzuto.dnr']
    end

    def assert_cookie(name, value)
      assert_equal value, cookies[name]
    end

    def assert_cookie_expiration(name, time)
      assert (full_cookies[name]['expires'] - time).abs < 20
    end

    def assert_ctx_ad_source_cookie(value)
      assert_cookie(CTX_AD_SOURCE_COOKIE, value)
      assert_cookie_expiration(CTX_AD_SOURCE_COOKIE, 30.days.from_now)
    end

    def assert_utm_source_cookie(value)
      assert_cookie(UTM_SOURCE_COOKIE, value)
      assert_cookie_expiration(UTM_SOURCE_COOKIE, 30.days.from_now)
    end

=begin
    COOKIE = Analytics::Dnr::Referrer::Middleware::DNR_COOKIE

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
=end
  end
end
