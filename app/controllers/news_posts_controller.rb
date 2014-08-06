class NewsPostsController < SectionContentController
  before_filter :find_posts, :only => :index
  before_filter :find_post, :only => :show

  def index
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def show
  end


  private

  def find_posts
    @news_posts = section_news_posts.paginate(:page => page_number)
  end

  def find_post
    @news_post = section_news_posts.find(params[:news_post_id])
  end
end
