require 'test_helper'

class UfollowupControllerTest < ActionController::TestCase
  context 'a GET to #show' do
    setup do
      @community = ApartmentCommunity.make
    end

    context 'with no email param' do
      setup do
        get :show, :id => @community.id
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:community) { @community }
    end

    context 'with email param set' do
      setup do
        @email = 'chris@viget.com'
        get :show, :id => @community.id, :email => @email
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:email) { @email }
      should_assign_to(:community) { @community }
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

      should_respond_with :success
      should_render_template :thank_you
      should_assign_to(:section) { @section }
      should_assign_to(:email) { @email }

      should 'erase the lasso cookie' do
        assert_nil cookies['ufollowup_email']
      end
    end

    context 'without an email in the ufollowup cookie' do
      setup do
        get :thank_you
      end

      should_respond_with :success
      should_render_template :thank_you
      should_assign_to(:section) { @section }
      should_not_assign_to(:email)
    end
  end
end
