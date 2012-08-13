require 'test_helper'

class Email::SubscriptionsControllerTest < ActionController::TestCase
  context 'GET to #destroy' do
    setup do
      @email = RecurringEmail.make(:recurring)

      get :destroy, :id => @email.token
    end

    should_respond_with :success

    should_render_template :destroy

    should 'set the state to unsubscribed' do
      @email.reload

      assert_equal 'unsubscribed', @email.state
    end
  end
end
