class StatesController < ApplicationController
  before_filter :load_state
  
  def show; end
  
  private
  
  def load_state
    @state = State.find_by_code!(params[:id])
  end
end
