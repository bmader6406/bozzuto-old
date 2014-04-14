class CountiesController < ApplicationController
  has_mobile_actions :index, :show

  before_filter :find_county, :except => :index
  before_filter :mobile_only

  def index
    @state = State.find_by_code!(params[:state_id])
    @counties = @state.counties.ordered_by_name
  end

  def show
    @apartment_communities = @county.apartment_communities.published.ordered_by_title
  end


  private

  def find_county
    @county = County.find(params[:id])
  end

  def mobile_only
    redirect_to metros_url unless mobile?
  end
end
