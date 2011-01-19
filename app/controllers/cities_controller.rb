class CitiesController < ApplicationController
  before_filter :load_city
  
  def show; end
  
  private
  
  def load_city
    @city = City.find(params[:id])
  end
end
