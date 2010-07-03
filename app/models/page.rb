class Page < ActiveRecord::Base
  acts_as_nested_set :scope => :section

  has_friendly_id :title,
    :use_slug => true,
    :scope    => :section

  belongs_to :section
  has_one :body_slideshow

  validates_presence_of :title


  alias_attribute :typus_name, :title

  def self.find_by_path(path)
    path = path.split('/')
    page = find(path.last)

    page.path == path ? page : (raise ActiveRecord::RecordNotFound)
  end

  def formatted_title
    if ancestors.size == 0
      title
    else
      "#{'&nbsp;' * ancestors.size * 3}&#8627; #{title}".html_safe
    end
  end

  def path
    self_and_ancestors.map { |page| page.cached_slug }
  end

  def first?
    lft == 1
  end
end
