class Email::SubscriptionsController < ApplicationController
  layout 'page'

  def destroy
    @email = RecurringEmail.find_by_token!(params[:id])

    @email.cancel_recurring!
  end
end
