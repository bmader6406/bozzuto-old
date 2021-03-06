class CommunitySearchesController < ApplicationController
  has_mobile_actions :show

  before_filter :process_params

  def show
    if mobile?
      search_for_mobile
    else
      search_for_desktop
    end
  end


  private

  def mobile_search_params
    params[:q].try(:strip)
  end

  # Convert params to the new syntax
  #
  #   search[city_id]   -> search[city_id_eq]
  #   search[county_id] -> search[county_id_eq]
  #
  # Eliminate empty strings from array values
  #
  #   ['', '', '2', '', ''] -> ['2']
  #
  def process_params
    return unless params[:search].present?

    params[:search] = params[:search].reduce(Hash.new) do |processed_params, (filter, value)|
      if %w(city_id county_id).include? filter
        processed_params.merge("#{filter}_eq" => value)
      elsif value.is_a? Array
        processed_params.merge(filter => value.map { |v| v.empty? ? nil : v }.compact)
      else
        processed_params.merge(filter => value)
      end.with_indifferent_access
    end
  end

  def search_for_mobile
    if mobile_search_params.present?
      @search = Bozzuto::Mobile::CommunitySearch.search(mobile_search_params)

      if @search.results?
        render :results
      end
    end
  end

  def search_for_desktop
    params[:search] ||= {}

    @partial_template = params[:template] || 'search'

    @search = Bozzuto::CommunitySearch.new(params[:search])

    respond_to do |format|
      format.html do
        render :action => :show, :layout => 'application'
      end
      format.js
    end
  end

  def geographic_filter
    @geographic_filter ||= @search.location
  end
  helper_method :geographic_filter

  def restart_search_path
    if params[:search][:in_state]
      community_search_path(:search => { :in_state => params[:search][:in_state] })
    else
      community_search_path
    end
  end
  helper_method :restart_search_path
end
