class Section < ActiveRecord::Base
  include Montage
  
  has_many :testimonials
  has_many :pages,
    :order     => 'lft ASC',
    :dependent => :destroy
  has_and_belongs_to_many :awards, :order => 'published_at DESC'
  has_and_belongs_to_many :news_posts, :order => 'published_at DESC'
  has_and_belongs_to_many :press_releases, :order => 'published_at DESC'
  has_many :projects
  has_one :contact_topic

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_inclusion_of :service, :in => [true, false]

  scope :services, :conditions => { :service => true }
  scope :ordered_by_title, :order => 'title ASC'


  def self.about
    find(:first, :conditions => { :about => true })
  end

  def self.news_and_press
    find 'news-press'
  rescue
    nil
  end

  def typus_name
    title
  end

  def aggregate?
    about?
  end
  
end
