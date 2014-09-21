class SearchesController < ApplicationController  
  before_filter :require_query

  def index
  end


  private

  def require_query
    redirect_to root_path unless query.present?
  end

  def query
    params[:q]
  end
  helper_method :query

  def search
    @search ||= Bozzuto::SiteSearch.search(query, params)
  end
  helper_method :search

  def results
    search.results
  end
  helper_method :results
end
