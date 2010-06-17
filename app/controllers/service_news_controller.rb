class ServiceNewsController < ApplicationController
  before_filter :find_service, :find_section

  def index
    @news_posts = @section.news_posts.paginate(:page => params[:page])
    @recent_posts = @section.news_posts.recent(3)
  end

  def show
    @post = @section.news_posts.find(params[:id])
  end


  private

  def find_service
    @service = Service.find_by_slug(params[:service_id])
  end

  def find_section
    @section = @service.section
  end
end
