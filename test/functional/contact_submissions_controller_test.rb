require 'test_helper'

class ContactSubmissionsControllerTest < ActionController::TestCase
  context 'ContactSubmissionsController' do
    context 'a GET to #show' do
      context 'with no topic param' do
        setup do
          get :show
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to :submission
      end

      context 'with a topic param' do
        setup do
          @topic = 'construction'
          get :show, :topic => @topic
        end

        should 'set the topic on the submission' do
          assert_equal @topic, assigns(:submission).topic
        end
      end
    end

    context 'a POST to #create' do
      context 'with missing fields' do
        setup do
          post :create, :contact_submission => {}
        end

        should_respond_with :success
        should_render_template :show
      end

      context 'with all fields present' do
        setup do
          @submission = ContactSubmission.make_unsaved
          post :create, :contact_submission => @submission.attributes
        end

        should_respond_with :redirect
        should_redirect_to('the thank you page') { thank_you_contact_path }
      end
    end

    context 'a GET to #thank_you' do
      setup do
        get :thank_you
      end

      should_respond_with :success
      should_render_template :thank_you
    end
  end
end
