class Email::RecentlyViewedController < ApplicationController
  def create
    @email = RecurringEmail.new(params[:recurring_email])
    @email.recurring = false

    if @email.save
      save_bozzuto_buzz
      redirect_to thank_you_email_recently_viewed_url
    else
      redirect_to :back, :flash => { :recently_viewed_errors => true }
    end
  end

  def thank_you
    render :thank_you, :layout => 'page'
  end


  private

  def save_bozzuto_buzz
    if params[:bozzuto_buzz].present? && email_address.present?
      Buzz.create(
        :email        => email_address,
        :buzzes       => 'Apartments',
        :affiliations => ''
      )
    end
  end

  def email_address
    params[:recurring_email][:email_address]
  end
end
