class CitiesController < ApplicationController
  has_mobile_actions :show

  before_filter :find_city, :mobile_only
  
  def show
    @apartment_communities = @city.apartment_communities.published.ordered_by_title
  end
  

  private
  
  def find_city
    @city = City.find(params[:id])
  end

  def mobile_only
    redirect_to metros_url unless mobile?
  end
end
