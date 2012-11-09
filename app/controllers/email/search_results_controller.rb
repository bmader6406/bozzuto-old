class Email::SearchResultsController < ApplicationController
  def create
    @email = RecurringEmail.new(params[:recurring_email])
    @email.recurring = true

    if @email.save
      save_bozzuto_buzz

      @email.send!

      redirect_to thank_you_email_search_results_url
    else
      redirect_to :back, :flash => { :search_results_errors => true }
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