class Page < ActiveRecord::Base
  include Montage
  
  acts_as_nested_set :scope => :section

  has_friendly_id :title,
    :use_slug => true,
    :scope    => :section

  after_save :set_path

  belongs_to :section

  has_one :masthead_slideshow, :dependent => :destroy
  has_one :body_slideshow, :dependent => :destroy

  validates_presence_of :title

  attr_protected :path

  alias_attribute :typus_name, :title

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


  protected

  def set_path
    self.path = self_and_ancestors.map { |page| page.cached_slug }.join('/')
    update_without_callbacks
    descendants.each(&:set_path)
  end
end
