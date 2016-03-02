class Page < ActiveRecord::Base
  include Montage
  include Bozzuto::Publishable
  extend FriendlyId
  
  acts_as_nested_set :scope => :section, :dependent => :destroy

  after_save :set_path

  belongs_to :section
  belongs_to :snippet

  has_one :masthead_slideshow
  has_one :body_slideshow
  has_one :carousel, :as => :content

  scope :for_sidebar_nav, -> { where(show_in_sidebar_nav: true) }

  validates :title,
            presence: true

  friendly_id :title, use: [:history, :scoped], :scope => [:section]

  attr_protected :path

  def to_s
    [section.try(:title), title].compact.join(' > ')
  end

  def display_name
    to_s
  end

  def to_label
    to_s
  end

  def formatted_title
    if ancestors.size == 0
      title
    else
      "#{'&nbsp;' * ancestors.size * 3}&#8627; #{title}".html_safe
    end
  end

  def first?
    lft == 1
  end

  def to_param
    path
  end

  def root_level?
    ancestors.size == 0
  end

  def mobile_content?
    mobile_body.present? && mobile_body.length > 10
  end


  private

  def set_path
    self.update_column(:path, self_and_ancestors.map(&:slug).join('/'))

    descendants.each { |d| d.send(:set_path) }
  end
end
