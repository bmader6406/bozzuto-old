class CitiesController < ApplicationController
  before_filter :find_city, :mobile_only
  
  def show
    @apartment_communities = @city.apartment_communities.published
  end
  

  private
  
  def find_city
    @city = City.find(params[:id])
  end

  def mobile_only
    redirect_to apartment_communities_url unless mobile?
  end
end
