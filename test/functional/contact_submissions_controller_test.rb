require 'test_helper'

class ContactSubmissionsControllerTest < ActionController::TestCase
  context 'ContactSubmissionsController' do
    setup do
      @section = Section.make(:about)
      @topic = ContactTopic.make
    end

    context 'a GET to #show' do
      browser_context do
        context 'with no topic param' do
          setup do
            get :show
          end

          should_respond_with :success
          should_render_template :show
          should_assign_to :submission
          should_assign_to(:section) { @section }
        end

        context 'with a topic param' do
          setup do
            get :show, :topic => @topic.to_param
          end

          should 'set the topic on the submission' do
            assert_equal @topic, assigns(:submission).topic
          end
        end
      end

      mobile_context do
        context 'with no topic param' do
          setup do
            get :show, :format => :mobile
          end

          should_respond_with :success
          should_render_template :show
          should_assign_to :submission
          should_assign_to(:section) { @section }
        end

        context 'with a topic param' do
          setup do
            get :show,
              :topic  => @topic.to_param,
              :format => :mobile
          end

          should 'set the topic on the submission' do
            assert_equal @topic, assigns(:submission).topic
          end
        end
      end

      context 'for KML format' do
        setup do
          get :show, :format => :kml
        end

        should_respond_with :success
        should_render_without_layout
        should_render_template :show

        should 'render the KML XML' do
          assert_match /<name>Bozzuto Corporate Office<\/name>/,
            @response.body
          assert_match /<description>7850 Walker Dr\., Suite 400, Greenbelt, MD 20770<\/description>/,
            @response.body
          assert_match /<coordinates>38.999647,-76.89595,0<\/coordinates>/,
            @response.body
        end
      end
    end

    context 'a POST to #create' do
      context 'with missing fields' do
        setup do
          assert_no_difference('ActionMailer::Base.deliveries.count') do
            post :create, :contact_submission => {}
          end
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:section) { @section }
      end

      context 'with all fields present' do
        setup do
          @submission = ContactSubmission.make_unsaved :topic => @topic

          assert_difference('ActionMailer::Base.deliveries.count', 1) do
            post :create,
              :contact_submission => @submission.attributes,
              :topic              => @topic.to_param
          end
        end

        should_respond_with :redirect
        should_redirect_to('the thank you page') { thank_you_contact_path }
        should_assign_to(:section) { @section }
        should 'save the email in the flash' do
          assert_equal @submission.email, flash[:contact_submission_email]
        end
      end
    end

    context 'a GET to #thank_you' do
      setup do
        get :thank_you
      end

      should_respond_with :success
      should_render_template :thank_you
      should_assign_to(:section) { @section }
    end
  end
end
