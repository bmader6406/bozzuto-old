class LandingPagesController < ApplicationController
  layout 'homepage'

  before_filter :find_page,                 :only => :show
  before_filter :redirect_to_canonical_url, :only => :show

  def show
    @state = @page.state
  end


  private

  def find_page
    @page = LandingPage.published.friendly.find(params[:id])
  end

  def redirect_to_canonical_url
    if request.path != landing_page_path(@page)
      redirect_to @page, :status => :moved_permanently
    end
  end

  def apartment_communities
    @apartment_communities ||= @page.apartment_communities.published.not_under_construction
  end
  helper_method :apartment_communities

  def home_communities
    @home_communities ||= @page.home_communities.published
  end
  helper_method :home_communities

  def featured_apartment_communities
    @featured_apartment_communities ||= @page.featured_apartment_communities.published
  end
  helper_method :featured_apartment_communities

  def popular_properties
    @popular_properties ||= @page.popular_properties.published
  end
  helper_method :popular_properties

  def projects
    @projects ||= @page.projects.published + @page.apartment_communities.published.under_construction
  end
  helper_method :projects

  def all_properties
    @all_properties ||= [
      apartment_communities,
      home_communities,
      featured_apartment_communities,
      popular_properties,
      projects
    ].flatten.compact.uniq
  end
  helper_method :all_properties
end
