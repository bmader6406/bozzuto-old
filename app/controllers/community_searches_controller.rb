class CommunitySearchesController < ApplicationController
  has_mobile_actions :show

  def show
    if mobile?
      search_for_mobile
    else
      search_for_desktop
    end
  end


  private

  def search_for_mobile
    if params[:q]
      @search = Bozzuto::CommunitySearch.search(params[:q])

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
