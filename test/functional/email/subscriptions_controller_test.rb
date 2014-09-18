require 'test_helper'

class Email::SubscriptionsControllerTest < ActionController::TestCase
  context 'GET to #destroy' do
    setup do
      @email = RecurringEmail.make(:recurring)

      get :destroy, :id => @email.token
    end

    should respond_with(:success)

    should render_template(:destroy)

    should 'set the state to unsubscribed' do
      @email.reload

      @email.state.should == 'unsubscribed'
    end
  end
end
