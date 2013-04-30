require 'test_helper'

class Email::RecentlyViewedControllerTest < ActionController::TestCase
  context 'POST to #create' do
    context 'with a valid email address' do
      setup do
        @address = Faker::Internet.email

        post :create,
             :recurring_email => {
               :email_address => @address,
               :property_ids  => [1, 2]
             }
      end

      should_redirect_to('the thank you page') { thank_you_email_recently_viewed_url }

      should_not_change('the number of buzzes') { Buzz.count }

      should 'create a non-recurring email' do
        assert !assigns(:email).recurring?
      end

      should 'save the recently viewed property ids' do
        assert_equal [1, 2], assigns(:email).property_ids
      end

      should "save the recurring email's id in the flash" do
        assert flash[:recurring_email_id] == assigns(:email).id
      end

      should_change('the number of deliveries', :by => 1) { ActionMailer::Base.deliveries.count }
    end

    context 'without a valid email address' do
      setup do
        @request.env['HTTP_REFERER'] = root_url

        post :create
      end

      should_redirect_to(:back) { root_url }

      should_not_change('the number of buzzes') { Buzz.count }

      should 'set the errors flag in the flash' do
        assert flash[:recently_viewed_errors]
      end
    end

    context 'when the Bozzuto Buzz checkbox is checked' do
      setup do
        @address = Faker::Internet.email

        post :create, :recurring_email => { :email_address => @address },
                      :bozzuto_buzz    => '1'
      end

      should_redirect_to('the thank you page') { thank_you_email_recently_viewed_url }

      should_change('the number of buzzes', :by => 1) { Buzz.count }

      should 'create the buzz with the email address' do
        assert_equal @address, Buzz.last.email
      end

      should "create the buzz with the 'Apartments' buzz checked" do
        assert_equal ['Apartments'], Buzz.last.buzzes
      end
    end
  end

  context 'GET to #thank_you' do
    context "without a recurring_email_id in the session" do
      setup do
        get :thank_you
      end

      should_respond_with(:success)
      should_render_template(:thank_you)
      should_not_assign_to(:email)
    end

    context "with a recurring_email_id in the session" do
      setup do
        @email = RecurringEmail.make

        get :thank_you, nil, nil, { :recurring_email_id => @email.id }
      end

      should_respond_with(:success)
      should_render_template(:thank_you)
      should_assign_to(:email) { @email }
    end
  end
end
