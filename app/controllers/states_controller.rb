class StatesController < ApplicationController
  before_filter :find_state, :mobile_only
  
  def show; end
  

  private
  
  def find_state
    @state = State.find_by_code!(params[:id])
  end

  def mobile_only
    redirect_to apartment_communities_url unless mobile?
  end
end
