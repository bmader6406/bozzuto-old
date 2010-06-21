class Section < ActiveRecord::Base
  has_many :news_posts,
    :conditions => { :published => true },
    :order      => 'published_at DESC'
  has_many :testimonials
  has_many :pages

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_inclusion_of :service, :in => [true, false]


  def typus_name
    title
  end

  alias_method :related_news_posts, :news_posts
  def news_posts
    aggregate? ? NewsPost.published : related_news_posts
  end

  alias_method :related_testimonials, :testimonials
  def testimonials
    aggregate? ? Testimonial.all : related_testimonials
  end

  def aggregate?
    cached_slug == 'about'
  end
end
