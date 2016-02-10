require 'test_helper'

class UfollowupControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    setup do
      @community = ApartmentCommunity.make
    end

    context 'with no email param' do
      setup do
        get :show, :apartment_community_id => @community.id
      end

      should respond_with(:success)
      should render_template(:show)
      should assign_to(:community) { @community }
    end

    context 'with email param set' do
      setup do
        @email = 'chris@viget.com'

        get :show,
            :apartment_community_id => @community.id,
            :email => @email
      end

      should respond_with(:success)
      should render_template(:show)
      should assign_to(:email) { @email }
      should assign_to(:community) { @community }
    end
  end

  context 'a GET to #thank_you' do
    setup do
      @section = Section.make :title => 'Apartments'
      @page = Page.make :section => @section
    end

    context 'with an email in the ufollowup cookie' do
      setup do
        @email = Faker::Internet.email
        @request.cookies['ufollowup_email'] = @email
        get :thank_you
      end

      should respond_with(:success)
      should render_template(:thank_you)
      should assign_to(:section) { @section }
      should assign_to(:email) { @email }

      should 'erase the lasso cookie' do
        assert_nil cookies['ufollowup_email']
      end
    end

    context 'without an email in the ufollowup cookie' do
      setup do
        get :thank_you
      end

      should respond_with(:success)
      should render_template(:thank_you)
      should assign_to(:section) { @section }

      # TODO fix `should_not assign_to` negative_failure_message error, RF 2-9-16
      # should_not assign_to(:email)
    end
  end
end
