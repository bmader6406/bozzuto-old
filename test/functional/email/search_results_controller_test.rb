require 'test_helper'

class Email::SearchResultsControllerTest < ActionController::TestCase
  context 'POST to #create' do
    context 'with a valid email address' do
      setup do
        @address = Faker::Internet.email

        expect {
          expect {
            post :create,
                 :recurring_email => {
                   :email_address => @address,
                   :property_ids  => [1, 2, 3]
                 }
          }.to_not change { Buzz.count }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      should redirect_to('the thank you page') { thank_you_email_search_results_url }

      should 'create a non-recurring email' do
        assert !assigns(:email).recurring?
      end

      should 'save the recently viewed property ids' do
        assert_equal ["1", "2", "3"], assigns(:email).property_ids
      end
    end

    context 'without a valid email address' do
      setup do
        @request.env['HTTP_REFERER'] = root_url

        expect {
          post :create
        }.to_not change { Buzz.count }
      end

      should redirect_to(:back) { root_url }

      should 'set the errors flag in the flash' do
        assert flash[:search_results_errors]
      end
    end

    context 'when the Bozzuto Buzz checkbox is checked' do
      setup do
        @address = Faker::Internet.email

        expect {
          post :create, :recurring_email => { :email_address => @address },
                        :bozzuto_buzz    => '1'
        }.to change { Buzz.count }.by(1)
      end

      should redirect_to('the thank you page') { thank_you_email_search_results_url }

      should 'create the buzz with the email address' do
        assert_equal @address, Buzz.last.email
      end

      should "create the buzz with the 'Apartments' buzz checked" do
        assert_equal ['Apartments'], Buzz.last.buzzes
      end
    end
  end

  context 'GET to #thank_you' do
    setup do
      get :thank_you
    end

    should respond_with(:success)
    should render_template(:thank_you)
  end
end
