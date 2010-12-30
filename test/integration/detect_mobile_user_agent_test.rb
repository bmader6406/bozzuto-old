require 'test_helper'

class DetectMobileUserAgentTest < ActionController::IntegrationTest
  def self.should_set_the_format_to(format)
    should "set the request format to #{format}" do
      assert_equal format.to_sym, @request.format.to_sym
    end
  end

  def self.should_set_the_device_to(device)
    should "set the device to #{device}" do
      assert_equal device.to_sym, @controller.device
    end
  end

  context 'A request' do
    context 'without a mobile user agent' do
      setup do
        get '/'
      end

      should_set_the_format_to :html
      should_set_the_device_to :browser
    end

    context 'with an Android user agent' do
      setup do
        get '/', nil, :user_agent => 'Mozilla/5.0 (Linux; U; Android 2.2; en-us; Droid Build/FRG22D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1'
      end

      should_set_the_format_to :mobile
      should_set_the_device_to :android
    end

    context 'with an iPhone user agent' do
      setup do
        get '/', nil, :user_agent => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7'
      end

      should_set_the_format_to :mobile
      should_set_the_device_to :iphone
    end

    context 'with an iPod touch user agent' do
      setup do
        get '/', nil, :user_agent => 'Mozilla/5.0 (iPod; U; CPU iPhone OS 3_1_1 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Mobile/7C145'
      end

      should_set_the_format_to :mobile
      should_set_the_device_to :iphone
    end

    context 'with an iPad user agent' do
      setup do
        get '/', nil, :user_agent => 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405'
      end

      should_set_the_format_to :html
      should_set_the_device_to :browser
    end

    context 'with a BlackBerry Bold user agent' do
      setup do
        get '/', nil, :user_agent => 'BlackBerry9700/5.0.0.423 Profile/MIDP-2.1 Configuration/CLDC-1.1 VendorID/100'
      end

      should_set_the_format_to :mobile
      should_set_the_device_to :blackberry
    end

    context 'with a BlackBerry Storm user agent' do
      setup do
        get '/', nil, :user_agent => 'BlackBerry9530/4.7.0.167 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/102 UP.Link/6.3.1.20.0'
      end

      should_set_the_format_to :mobile
      should_set_the_device_to :blackberry
    end
  end
end
