class CommunitySearchesController < ApplicationController
  before_filter :mobile_only

  def show
    if params[:q]
      @search = Bozzuto::CommunitySearch.search(params[:q])
      if @search.results?
        render :results
      end
    end
  end


  private

  def mobile_only
    redirect_to apartment_communities_url unless mobile?
  end
end
