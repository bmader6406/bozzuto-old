class NewsController < ApplicationController
  before_filter :find_section, :find_recent_posts
  before_filter :find_posts, :only => :index
  before_filter :find_post, :only => :show

  def index
  end

  def show
  end


  private

  def find_section
    @section = Section.find(params[:section])
  end

  def find_recent_posts
    @recent_posts = @section.news_posts.recent(3)
  end

  def find_posts
    @news_posts = @section.news_posts.paginate(:page => params[:page])
  end

  def find_post
    @news_post = @section.news_posts.find(params[:news_post_id])
  end
end
