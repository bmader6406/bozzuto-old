require 'test_helper'

class Email::RecentlyViewedControllerTest < ActionController::TestCase
  context 'POST to #create' do
    context 'with a valid email address' do
      setup do
        @address = Faker::Internet.email

        expect {
          expect {
            post :create,
                 :recurring_email => {
                   :email_address => @address,
                   :property_ids  => [1, 2]
                 }
          }.to_not change { Buzz.count }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      should redirect_to('the thank you page') { thank_you_email_recently_viewed_url }

      should 'create a non-recurring email' do
        assigns(:email).recurring?.should == false
      end

      should 'save the recently viewed property ids' do
        assigns(:email).property_ids.should == ["1", "2"]
      end

      should "save the recurring email's id in the flash" do
        flash[:recurring_email_id].should == assigns(:email).id
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
        flash[:recently_viewed_errors].should be_present
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

      should redirect_to('the thank you page') { thank_you_email_recently_viewed_url }

      should 'create the buzz with the email address' do
        Buzz.last.email.should == @address
      end

      should "create the buzz with the 'Apartments' buzz checked" do
        Buzz.last.buzzes.should == ['Apartments']
      end
    end
  end

  context 'GET to #thank_you' do
    context "without a recurring_email_id in the session" do
      setup do
        get :thank_you
      end

      should respond_with(:success)
      should render_template(:thank_you)
    end

    context "with a recurring_email_id in the session" do
      setup do
        @email = RecurringEmail.make

        get :thank_you, nil, nil, { :recurring_email_id => @email.id }
      end

      should respond_with(:success)
      should render_template(:thank_you)
      should assign_to(:email) { @email }
    end
  end
end
