class Section < ActiveRecord::Base
  has_many :testimonials
  has_many :pages,
    :order     => 'lft ASC',
    :dependent => :destroy
  has_and_belongs_to_many :awards, :order => 'published_at DESC'
  has_and_belongs_to_many :news_posts, :order => 'published_at DESC'
  has_and_belongs_to_many :press_releases, :order => 'published_at DESC'
  has_many :projects

  has_friendly_id :title, :use_slug => true

  has_attached_file :left_montage_image,
    :url => '/system/:class/:id/montage/:style_left_montage_image.:extension',
    :styles => { :normal => '250x148#' },
    :default_style => :normal

  has_attached_file :middle_montage_image,
    :url => '/system/:class/:id/montage/:style_middle_montage_image.:extension',
    :styles => { :normal => '540x148#' },
    :default_style => :normal

  has_attached_file :right_montage_image,
    :url => '/system/:class/:id/montage/:style_right_montage_image.:extension',
    :styles => { :normal => '310x148#' },
    :default_style => :normal

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_inclusion_of :service, :in => [true, false]

  named_scope :services, :conditions => { :service => true }
  named_scope :ordered_by_title, :order => 'title ASC'


  def self.about
    find(:first, :conditions => { :about => true })
  end

  def typus_name
    title
  end

  def aggregate?
    about?
  end

  def montage?
    left_montage_image? && middle_montage_image? && right_montage_image?
  end
end
