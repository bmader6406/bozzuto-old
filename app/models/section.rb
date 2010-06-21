class Section < ActiveRecord::Base
  has_one :service
  has_many :news_posts,
    :conditions => { :published => true },
    :order      => 'published_at DESC'
  has_many :testimonials

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title

  def typus_name
    title
  end

  alias_method :related_news_posts, :news_posts
  def news_posts
    if cached_slug == 'about'
      NewsPost.published
    else
      related_news_posts
    end
  end
end
