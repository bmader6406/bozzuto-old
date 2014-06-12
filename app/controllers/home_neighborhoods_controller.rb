class HomeNeighborhoodsController < ApplicationController
  has_mobile_actions :show

  def show
  end

  def index
  end

  private

  def neighborhood
    @neighborhood ||= HomeNeighborhood.find(params[:id])
  end
  helper_method :neighborhood

  def neighborhoods
    @neighborhoods ||= HomeNeighborhood.positioned
  end
  helper_method :neighborhoods
end
