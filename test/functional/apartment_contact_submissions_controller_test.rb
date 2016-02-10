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
            should assign_to(:submission)
            should assign_to(:page) { @page }
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
            should assign_to(:submission)
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
            should assign_to(:submission)
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
            should assign_to(:submission)
          end
        end
      end

      context 'POST to #create' do
        context 'with an invalid submission' do
          desktop_device do
            setup do
              @submission = UnderConstructionLead.new

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes
            end

            should respond_with(:success)
            should render_with_layout(:community)
            should render_template(:show)
            should assign_to(:submission)

            should 'have errors on the submission' do
              assert assigns(:submission).errors.count > 0
            end
          end

          mobile_device do
            context 'with an invalid submission' do
              setup do
                @submission = UnderConstructionLead.new

                post :create,
                  :apartment_community_id => @community.to_param,
                  :submission             => @submission.attributes
              end

              should respond_with(:success)
              should render_with_layout(:application)
              should render_template(:show)
              should assign_to(:submission)

              should 'have errors on the submission' do
                assert assigns(:submission).errors.count > 0
              end
            end
          end
        end

        context 'with a valid submission' do
          desktop_device do
            setup do
              @submission = UnderConstructionLead.make_unsaved

              expect {
                post :create,
                  :apartment_community_id => @community.to_param,
                  :submission             => @submission.attributes
              }.to change { UnderConstructionLead.count }.by(1)
            end

            should respond_with(:redirect)
            should redirect_to('the contact path') { thank_you_apartment_community_contact_path(@community) }
            should assign_to(:submission)

            should 'save the email in the flash' do
              assert_equal @submission.email, flash[:apartment_contact_email]
            end

            should 'save the form type in the flash' do
              assert_equal 'under_construction', flash[:contact_form]
            end
          end

          mobile_device do
            setup do
              @submission = UnderConstructionLead.make_unsaved

              expect {
                post :create,
                  :apartment_community_id => @community.to_param,
                  :submission             => @submission.attributes
              }.to change { UnderConstructionLead.count }.by(1)
            end

            should respond_with(:redirect)
            should redirect_to('the contact path') { thank_you_apartment_community_contact_path(@community) }
            should assign_to(:submission)

            should 'save the email in the flash' do
              assert_equal @submission.email, flash[:apartment_contact_email]
            end

            should 'save the form type in the flash' do
              assert_equal 'under_construction', flash[:contact_form]
            end
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
          end

          mobile_device do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should respond_with(:success)
            should render_with_layout(:application)
            should render_template(:show)
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
