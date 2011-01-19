class CountiesController < ApplicationController
  before_filter :load_county, :except => :index
  
  def index
    @state = State.find_by_code!(params[:state_id])
  end
  
  def show; end
  
  private
  
  def load_county
    @county = County.find(params[:id])
  end
end
