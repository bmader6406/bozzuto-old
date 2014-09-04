require 'test_helper'

class SslRequirementTest < ActionController::IntegrationTest
  def enable_ssl(klass)
    klass.any_instance.stubs(:ssl_enabled? => true)
  end

  context "A request" do
    setup do
      @admin_user = TypusUser.make
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

    context "to the sign in page" do
      before do
        enable_ssl(TypusController)
      end

      context "via http" do
        before do
          get '/admin/sign_in'
        end

        it "redirects to the https version" do
          assert_redirected_to 'https://www.example.com/admin/sign_in'
        end
      end

      context "via https" do
        before do
          https!
          get '/admin/sign_in'
        end

        it "responds successfully" do
          assert_response :success
        end
      end
    end

    context "to an admin page" do
      before do
        enable_ssl(Admin::ApartmentCommunitiesController)
      end

      context "via http" do
        before do
          get '/admin/apartment_communities'
        end

        it "redirects to the https version" do
          assert_redirected_to 'https://www.example.com/admin/apartment_communities'
        end
      end

      context "via https" do
        before do
          https!

          # sign in
          post '/admin/sign_in',
               :typus_user => {
                 :email    => @admin_user.email,
                 :password => 'password'
               }

          get '/admin/apartment_communities'
        end

        it "responds successfully" do
          assert_response :success
        end
      end
    end
  end
end
