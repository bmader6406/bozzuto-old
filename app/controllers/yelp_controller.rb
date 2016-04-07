class YelpController < ApplicationController
  def show
    render json: Yelp.client.search_by_coordinates(coordinates, search_params)
  end

  private

  def coordinates
    params.require(:coordinates).permit(:latitude, :longitude)
  end

  def search_params
    params.require(:search).permit(:category_filter, :limit, :radius)
  end
end
