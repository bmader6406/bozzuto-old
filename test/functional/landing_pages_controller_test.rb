require 'test_helper'

class LandingPagesControllerTest < ActionController::TestCase
  context 'LandingPagesController' do
    setup do
      @page      = LandingPage.make
      @city      = City.make(:state => @page.state)
      @community = ApartmentCommunity.make(:city => @city)
    end

    context 'a GET to #show' do
      browser_context do
        context 'with a canonical URL' do
          setup do
            get :show, :id => @page.to_param
          end

          should_respond_with :success
          should_render_with_layout :homepage
          should_render_template :show
          should_assign_to(:page) { @page }
          should_assign_to(:state) { @page.state }
        end

        context 'with a non-canonical URL' do
          context 'that uses a slug' do
            setup do
              old_slug = @page.cached_slug

              @page.update_attributes(:title => 'Hooray')

              get :show, :id => old_slug
            end

            should_respond_with :redirect
            should_redirect_to('the canonical URL') { landing_page_url(@page) }
          end

          context 'that uses an ID number' do
            setup do
              get :show, :id => @page.id
            end

            should_respond_with :redirect
            should_redirect_to('the canonical URL') { landing_page_url(@page) }
          end
        end
      end

      mobile_context do
        setup do
          get :show, :id => @page.to_param
        end

        should_redirect_to_home_page
      end
    end
  end
end
