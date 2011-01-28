class StatesController < ApplicationController
  before_filter :find_state
  
  def show; end
  

  private
  
  def find_state
    @state = State.find_by_code!(params[:id])
  end
end
