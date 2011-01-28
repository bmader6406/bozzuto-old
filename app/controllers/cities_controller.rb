class CitiesController < ApplicationController
  before_filter :find_city
  
  def show
    @apartment_communities = @city.apartment_communities.published
  end
  

  private
  
  def find_city
    @city = City.find(params[:id])
  end
end
