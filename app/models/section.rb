class Section < ActiveRecord::Base
  include Montage
  extend FriendlyId

  has_one :contact_topic
  
  has_many :testimonials
  has_many :projects
  has_many :pages,        -> { order(lft: :asc) }, dependent: :destroy

  has_and_belongs_to_many :awards,         -> { order(published_at: :desc) }
  has_and_belongs_to_many :news_posts,     -> { order(published_at: :desc) }
  has_and_belongs_to_many :press_releases, -> { order(published_at: :desc) }

  friendly_id :title, use: [:history]

  validates :title,
            presence: true,
            uniqueness: true

  scope :services,         -> { where(service: true) }
  scope :ordered_by_title, -> { order(title: :asc) }

  def self.about
    find_by(about: true)
  end

  def aggregate?
    about?
  end

  def to_label
    title
  end

  def to_s
    title
  end

  def to_param
    if service?
      "services/#{super}"
    else
      super
    end
  end
end
