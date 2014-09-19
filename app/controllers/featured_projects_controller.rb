class FeaturedProjectsController < ApplicationController
  has_mobile_actions :index, :show

  before_filter :mobile_only


  def index
    @projects = Project.featured_mobile
  end

  def show
    @project = Project.find(params[:id])
  end


  private

  def mobile_only
    redirect_to page_path('services') unless mobile?
  end
end
