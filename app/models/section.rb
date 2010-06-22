class Section < ActiveRecord::Base
  has_many :news_posts,
    :conditions => { :published => true },
    :order      => 'published_at DESC'
  has_many :testimonials
  has_many :pages,
    :order     => 'lft ASC',
    :dependent => :destroy

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_inclusion_of :service, :in => [true, false]

  named_scope :services, :conditions => { :service => true }


  def typus_name
    title
  end

  def news_posts_with_aggregation
    aggregate? ? NewsPost.published : news_posts_without_aggregation
  end
  alias_method_chain :news_posts, :aggregation

  def testimonials_with_aggregation
    aggregate? ? Testimonial.all : testimonials_without_aggregation
  end
  alias_method_chain :testimonials, :aggregation

  def aggregate?
    cached_slug == 'about'
  end
end
