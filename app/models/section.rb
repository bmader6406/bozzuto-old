class Section < ActiveRecord::Base
  include Montage
  include FriendlyId

  has_one :contact_topic
  
  has_many :testimonials
  has_many :projects
  has_many :pages, -> { order(lft: :asc) }, dependent: :destroy

  has_and_belongs_to_many :awards,         -> { order(published_at: :desc) }
  has_and_belongs_to_many :news_posts,     -> { order(published_at: :desc) }
  has_and_belongs_to_many :press_releases, -> { order(published_at: :desc) }

  friendly_id :title, use: [:slugged]

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_inclusion_of :service, :in => [true, false]

  scope :services,         -> { where(service: true) }
  scope :ordered_by_title, -> { order(title: :asc) }

  def self.about
    find(:first, :conditions => { :about => true })
  end

  def to_param
    if service?
      "services/#{super}"
    else
      super
    end
  end

  def typus_name
    title
  end

  def aggregate?
    about?
  end
  
end
