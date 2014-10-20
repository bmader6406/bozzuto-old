require 'test_helper'

class ApartmentContactSubmissionsControllerTest < ActionController::TestCase
  context 'ApartmentContactSubmissionsController' do
    context 'community is under construction' do
      setup do
        @community = ApartmentCommunity.make(:under_construction => true)
      end

      context 'GET to #show' do
        context 'with a community that is not published' do
          setup { @community.update_attribute(:published, false) }

          all_devices do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:not_found)
          end
        end

        context 'with a contact page' do
          setup do
            @page = PropertyContactPage.make(:property => @community)
          end

          desktop_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:community)
            should render_template(:show)
            should assign_to(:page) { @page }
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
            should assign_to(:page) { @page }
          end
        end

        context 'without a contact page' do
          desktop_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:community)
            should render_template(:show)
            should_not assign_to(:page)
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
            should_not assign_to(:page)
          end
        end
      end

      context 'GET to #thank_you' do
        desktop_device do
          setup do
            get :thank_you, :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:thank_you)
          should assign_to(:community)
        end

        mobile_device do
          setup do
            get :thank_you, :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:thank_you)
          should assign_to(:community)
        end
      end
    end

    context 'community is showing lead2lease form' do
      setup do
        @community = ApartmentCommunity.make(:show_lead_2_lease => true, :lead_2_lease_email => 'bruce@wayne.com')
      end

      context 'GET to #show' do
        context 'with a contact page' do
          setup do
            @page = PropertyContactPage.make(:property => @community)
          end

          desktop_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:community)
            should render_template(:show)
            should assign_to(:page) { @page }
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
            should assign_to(:page) { @page }
          end
        end

        context 'without a contact page' do
          desktop_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:community)
            should render_template(:show)
            should_not assign_to(:page)
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
            should_not assign_to(:page)
          end
        end
      end

      context "GET to #thank_you" do
        context "mmurid is saved in the session" do
          setup do
            url = "http://cvt.mydas.mobi/handleConversion?goalid=26148&urid=batman"

            @mm_request = stub_request(:get, url).to_return(:status => 200)

            get :thank_you, { :apartment_community_id => @community.to_param },
                            { :mmurid => 'batman' }
          end

          should "clear the mmurid from the session" do
            assert_requested(@mm_request)

            assert_nil session[:mmurid]
          end
        end

        desktop_device do
          setup do
            get :thank_you, :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:community)
          should render_template(:thank_you)
          should assign_to(:community)
        end

        mobile_device do
          setup do
            get :thank_you,
              :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should render_template(:thank_you)
          should assign_to(:community)
        end
      end
    end
  end
end
