require 'test_helper'

class LandingPagesControllerTest < ActionController::TestCase
  context 'LandingPagesController' do
    setup do
      @page      = LandingPage.make
      @city      = City.make(:state => @page.state)
      @community = ApartmentCommunity.make(:city => @city)
    end

    context 'a GET to #show' do
      all_devices do
        context 'with a canonical URL' do
          setup do
            get :show, :id => @page.to_param
          end

          should respond_with(:success)
          should render_with_layout(:homepage)
          should render_template(:show)
          should assign_to(:page) { @page }
          should assign_to(:state) { @page.state }
        end

        context 'with a non-canonical URL' do
          context 'that uses a slug' do
            setup do
              old_slug = @page.slug

              @page.update_attributes(
                title: 'Hooray',
                slug: nil
              )

              get :show, :id => old_slug
            end

            should respond_with(:redirect)
            should redirect_to('the canonical URL') { landing_page_url(@page) }
          end

          context 'that uses an ID number' do
            setup do
              get :show, :id => @page.id
            end

            should respond_with(:redirect)
            should redirect_to('the canonical URL') { landing_page_url(@page) }
          end
        end
      end
    end
  end
end
