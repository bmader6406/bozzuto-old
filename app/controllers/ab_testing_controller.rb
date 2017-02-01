class AbTestingController < ApplicationController
  before_action :redirect_to_homepage, if: :mobile?

  def homepage
    @home_page = HomePage.first
  end

  private

  def home?
    params[:action] == 'homepage'
  end
  helper_method :home?

  def redirect_to_homepage
    redirect_to root_path
  end

  def metros
    @metros ||= Metro.positioned.select(&:has_communities?)
  end
  helper_method :metros
end
