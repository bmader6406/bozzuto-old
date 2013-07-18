require 'test_helper'

class MobileSiteTest < ActionController::IntegrationTest
  def self.should_have_page_content(content)
    should "page should have content #{content}" do
      assert_match /#{content}/, @response.body
    end
  end

  def self.should_respond_with_desktop_site
    should_have_page_content 'Bozzuto Desktop'
  end

  def self.should_respond_with_mobile_site
    should_have_page_content 'Bozzuto Mobile'
  end


  setup do
    @home_page = HomePage.new(
      :body        => 'Bozzuto Desktop',
      :mobile_body => 'Bozzuto Mobile'
    )
    @home_page.save(false)
  end

  context "in a browser" do
    context "without forcing the mobile site" do
      setup do
        get '/', nil, :user_agent => desktop_user_agent
      end

      should_respond_with_desktop_site
    end

    context "forcing the mobile site" do
      setup do
        get '/', { :full_site => '0' }, :user_agent => desktop_user_agent
      end

      should_respond_with_mobile_site
    end
  end

  context "on a mobile device" do
    context "without forcing the full site" do
      setup do
        get '/', nil, :user_agent => mobile_user_agent
      end

      should_respond_with_mobile_site
    end

    context "forcing the full site" do
      setup do
        get '/', { :full_site => '1' }, :user_agent => mobile_user_agent
      end

      should_respond_with_desktop_site
    end
  end


  def desktop_user_agent
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/534.19 (KHTML, like Gecko) Chrome/11.0.661.0 Safari/534.19'
  end

  def mobile_user_agent
    'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7'
  end
end
