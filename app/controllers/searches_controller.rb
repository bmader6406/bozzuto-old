class SearchesController < ApplicationController  
  browser_only!

  def index
    search_params = {:sites => 'bozzuto.com,bozweb.bozzuto.com'}
    search_params[:start] = params[:start] if params[:start].present?
    @query = params[:q]

    if @query.present?
      @search = BOSSMan::Search.web(@query, search_params)
      render
    else
      redirect_to '/'
    end
  end
end
