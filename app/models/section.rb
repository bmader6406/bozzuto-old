class Section < ActiveRecord::Base
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
    if aggregate?
      NewsPost.published
    else
      related_news_posts
    end
  end

  alias_method :related_testimonials, :testimonials
  def testimonials
    if aggregate?
      Testimonial.all
    else
      related_testimonials
    end
  end

  def aggregate?
    cached_slug == 'about'
  end
end
