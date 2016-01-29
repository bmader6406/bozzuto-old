class Page < ActiveRecord::Base
  include Montage
  include Bozzuto::Publishable
  
  #acts_as_archive :indexes => [:id, :cached_slug]
  #class Archive < ActiveRecord::Base
  #  def section_title
  #    ::Section.find(self.section_id).title
  #  end
  #end
  
  acts_as_nested_set :scope => :section, :dependent => :destroy

  has_friendly_id :title,
    :use_slug => true,
    :scope    => :section

  after_save :set_path

  belongs_to :section
  belongs_to :snippet

  has_one :masthead_slideshow
  has_one :body_slideshow
  has_one :carousel, :as => :content

  scope :for_sidebar_nav, -> { where(show_in_sidebar_nav: true) }

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
    self.path = self_and_ancestors.map { |page| page.cached_slug }.join('/')
    update_without_callbacks
    descendants.each { |d| d.send(:set_path) }
  end
end
