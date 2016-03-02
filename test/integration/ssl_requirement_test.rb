require 'test_helper'

class SslRequirementTest < ActionDispatch::IntegrationTest
  def enable_ssl(klass)
    klass.any_instance.stubs(:ssl_enabled? => true)
  end

  def require_ssl(klass)
    klass.any_instance.stubs(:ssl_required? => true)
  end

  context "A request" do
    setup do
      @admin_user = AdminUser.make
    end

    context "to a user-facing page" do
      before do
        enable_ssl(HomePagesController)
      end

      context "via http" do
        before do
          get '/'
        end

        it "does nothing" do
          assert_response :success
        end
      end

      context "via https" do
        before do
          https!
          get '/'
        end

        it "redirects to the http version" do
          assert_redirected_to 'http://www.example.com/'
        end
      end
    end

    context "when SSL is required" do
      before do
        enable_ssl(HomePagesController)
        require_ssl(HomePagesController)
      end

      context "via http" do
        before do
          get '/'
        end

        it "redirects to the HTTPS version" do
          assert_redirected_to 'https://www.example.com/'
        end
      end
    end
  end
end
