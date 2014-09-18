require 'test_helper'

class DetectMobileUserAgentTest < ActionController::IntegrationTest
  def self.should_set_the_format_to(format)
    should "set the request format to #{format}" do
      assert_equal format.to_sym, @request.format.to_sym
    end
  end

  def self.should_set_the_device_to(device)
    should "set the device to #{device}" do
      assert_equal device.to_sym, @controller.send(:device)
    end
  end

  context 'A request' do
    context 'without a user agent' do
      setup do
        get '/'
      end

      should_set_the_format_to :html
      should_set_the_device_to :browser
    end

    context 'with an iPad user agent' do
      setup do
        get '/', nil, 'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405'
      end

      should_set_the_format_to :html
      should_set_the_device_to :browser
    end

    context 'with desktop user agent' do
      desktop_user_agents = [
        {
          :name => 'Firefox',
          :ua   => 'Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.9) Gecko/20100824 Firefox/3.6.9 ( .NET CLR 3.5.30729; .NET CLR 4.0.20506)'
        },
        {
          :name => 'Safari',
          :ua   => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; en-us) AppleWebKit/534.16+ (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4'
        },
        {
          :name => 'Chrome',
          :ua   => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.19 (KHTML, like Gecko) Chrome/11.0.661.0 Safari/534.19'
        },
        {
          :name => 'IE',
          :ua   => 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 1.1.4322)'
        },
        {
          :name => 'Opera',
          :ua   => 'Opera/9.80 (Windows NT 6.1; U; en-US) Presto/2.7.62 Version/11.01'
        },
      ]

      desktop_user_agents.each do |agent|
        context agent[:name] do
          setup do
            get '/', nil, 'HTTP_USER_AGENT' => agent[:ua]
          end

          should_set_the_format_to :html
          should_set_the_device_to :browser
        end
      end
    end

    context 'with mobile user agent' do
      mobile_user_agents = [
        {
          :name   => 'iPhone',
          :device => :iphone,
          :ua     => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7'
        },
        {
          :name   => 'iPod Touch',
          :device => :iphone,
          :ua     => 'Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_1 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Mobile/7C145'
        },
        {
          :name   => 'BlackBerry Bold',
          :device => :blackberry,
          :ua     => 'BlackBerry9700/5.0.0.423 Profile/MIDP-2.1 Configuration/CLDC-1.1 VendorID/100'
        },
        {
          :name   => 'BlackBerry Storm',
          :device => :blackberry,
          :ua     => 'BlackBerry9530/4.7.0.167 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/102 UP.Link/6.3.1.20.0'
        },
        {
          :name   => 'IEMobile',
          :device => :iemobile,
          :ua     => 'HTC_Touch_3G Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 7.11)'
        },
        {
          :name   => 'webOS',
          :device => :webos,
          :ua     => 'Mozilla/5.0 (webOS/1.0; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Pre/1.0'
        },
        {
          :name   => 'Symbian',
          :device => :symbian,
          :ua     => 'NokiaC5-00/061.005 (SymbianOS/9.3; U; Series60/3.2 Mozilla/5.0; Profile/MIDP-2.1 Configuration/CLDC-1.1) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 Safari/525 3gpp-gba'
        },
        {
          :name   => 'Fennec on Android',
          :device => :android,
          :ua     => 'Mozilla/5.0 (Android; Linux armv7l; rv:2.0b9pre) Gecko/20110103 Firefox/4.0b9pre Fennec/4.0b4pre'
        },
        {
          :name   => 'Fennec',
          :device => :fennec,
          :ua     => 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0b8) Gecko/20101221 Firefox/4.0b8 Fennec/4.0b3'
        },
        {
          :name   => 'Android',
          :device => :android,
          :ua     => 'Mozilla/5.0 (Linux; U; Android 2.2; en-us; Droid Build/FRG22D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'
        },
        {
          :name   => 'NetFront',
          :device => :netfront,
          :ua     => 'SAMSUNG-C5212/C5212XDIK1 NetFront/3.4 Profile/MIDP-2.0 Configuration/CLDC-1.1'
        },
        {
          :name   => 'Maemo',
          :device => :maemo,
          :ua     => 'Mozilla/5.0 (X11; U; Linux armv7l; en-GB; rv:1.9.2a1pre) Gecko/20090928 Firefox/3.5 Maemo Browser 1.4.1.22 RX-51 N900'
        }
      ]

      mobile_user_agents.each do |agent|
        context agent[:name] do
          setup do
            get '/', nil, 'HTTP_USER_AGENT' => agent[:ua]
          end

          should_set_the_format_to :mobile
          should_set_the_device_to agent[:device]
        end
      end
    end
  end
end
