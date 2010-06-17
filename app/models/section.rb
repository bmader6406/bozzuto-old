class Section < ActiveRecord::Base
  has_one :service
  has_many :news_posts,
    :conditions => { :published => true },
    :order      => 'published_at DESC'
  has_many :testimonials

  validates_presence_of :title
  validates_uniqueness_of :title

  def typus_name
    title
  end
end
