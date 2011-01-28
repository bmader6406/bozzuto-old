class CountiesController < ApplicationController
  before_filter :find_county, :except => :index
  before_filter :mobile_only

  def index
    @state = State.find_by_code!(params[:state_id])
  end

  def show; end


  private

  def find_county
    @county = County.find(params[:id])
  end

  def mobile_only
    redirect_to apartment_communities_url unless mobile?
  end
end
