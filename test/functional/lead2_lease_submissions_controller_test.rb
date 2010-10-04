require 'test_helper'

class Lead2LeaseSubmissionsControllerTest < ActionController::TestCase
  context 'Lead2LeaseSubmissionsController' do
    setup { @community = ApartmentCommunity.make }

    context 'a GET to #show' do
      setup do
        get :show, :apartment_community_id => @community.to_param
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to :submission
    end

    context 'a POST to #create' do
      context 'with an invalid submission' do
        setup do
          @submission = Lead2LeaseSubmission.new
          post :create,
            :apartment_community_id => @community.to_param,
            :submission => @submission.attributes
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to :submission

        should 'have errors on the submission' do
          assert assigns(:submission).errors.count > 0
        end
      end

      context 'with a valid submission' do
        setup do
          @submission = Lead2LeaseSubmission.make_unsaved
          post :create,
            :apartment_community_id => @community.to_param,
            :submission => @submission.attributes
        end

        should_respond_with :redirect
        should_redirect_to('the contact path') {
          apartment_community_lead2_lease_submissions_path(@community)
        }
        should_assign_to :submission
        should_change('mail deliveries', :by => 1) { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
