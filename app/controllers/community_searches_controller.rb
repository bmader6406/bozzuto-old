class CommunitySearchesController < ApplicationController
  def show
    if params[:q]
      @search = Bozzuto::CommunitySearch.search(params[:q])
      if @search.results?
        render :results
      end
    end
  end
end
