class NewsController < ApplicationController
  layout 'page'

  before_filter :find_section, :find_recent_posts
  before_filter :find_posts, :only => :index
  before_filter :find_post, :only => :show

  def index
  end

  def show
  end


  private

  def find_recent_posts
    @recent_posts = @section.section_news.published.recent(3)
  end

  def find_posts
    @news_posts = @section.section_news.published.paginate(:page => params[:page])
  end

  def find_post
    @news_post = @section.section_news.published.find(params[:news_post_id])
  end
end
