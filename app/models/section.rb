class Section < ActiveRecord::Base
  has_many :news_posts, :order => 'published_at DESC'
  has_many :testimonials
  has_many :pages,
    :order     => 'lft ASC',
    :dependent => :destroy
  has_many :awards, :order => 'published_at DESC'

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_inclusion_of :service, :in => [true, false]

  named_scope :services, :conditions => { :service => true }


  def self.about
    find('about')
  end

  def typus_name
    title
  end

  def section_news
    aggregate? ? NewsPost.all : news_posts
  end

  def section_testimonials
    aggregate? ? Testimonial.all : testimonials
  end

  def about?
    cached_slug == 'about'
  end
  alias :aggregate? :about?
end
