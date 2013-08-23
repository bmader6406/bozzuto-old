class SearchesController < ApplicationController  
  def index
    search_params = { :sites => 'bozzuto.com' }
    search_params[:start] = params[:start] if params[:start].present?
    @query = params[:q]

    if @query.present?
      @search  = BOSSMan::Search.web(sanitize_query(@query), search_params)
      @results = @search.results || []
    else
      redirect_to '/'
    end
  end


  private

  def sanitize_query(query)
    query.gsub(/[+()]/, ' ')
  end
end
