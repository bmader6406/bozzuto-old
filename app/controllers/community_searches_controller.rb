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
      @search = Bozzuto::CommunitySearch.search(mobile_search_params)

      if @search.results?
        render :results
      end
    end
  end

  def search_for_desktop
    params[:search] ||= {}

    @partial_template = params[:template] || 'search'

    @search = ApartmentCommunity.published.featured_order.search(params[:search])

    @communities = @search.all(:include => [:property_features, :city]).group_by { |c| c.state.name }

    @ordered_states = State.all.sort { |a, b|
      (@communities[b.name].try(:count) || 0) <=> (@communities[a.name].try(:count) || 0)
    }

    respond_to do |format|
      format.html do
        render :action => :show, :layout => 'application'
      end
      format.js
    end
  end

  def geographic_filter
    #:nocov:
    @geographic_filter ||= begin
    #:nocov:
      search = params[:search]

      if search[:in_state].present?
        State.find_by_id(search[:in_state])
      elsif search[:county_id_eq].present?
        County.find_by_id(search[:county_id_eq])
      elsif search[:city_id_eq].present?
        City.find_by_id(search[:city_id_eq])
      end
    end
  end
  helper_method :geographic_filter
end
