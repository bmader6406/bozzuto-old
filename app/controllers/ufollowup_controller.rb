class UfollowupController < ApplicationController
  layout 'community'

  def show
    @email = params[:email]
    @community = Property.find(params[:id])
  end
end
