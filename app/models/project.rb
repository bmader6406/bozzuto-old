class Project < Property
  #acts_as_archive :indexes => [:id]
  
  acts_as_list :scope => :section

  has_many :data_points,
    :class_name => 'ProjectDataPoint',
    :order      => 'position ASC'
  has_many :updates,
    :class_name => 'ProjectUpdate',
    :order      => 'published_at DESC'
  belongs_to :section
  has_and_belongs_to_many :project_categories, :order => 'position ASC'


  validates_presence_of :completion_date
  validates_inclusion_of :has_completion_date, :in => [true, false]


  scope :in_section, lambda { |section|
    { :conditions => { :section_id => section.id } }
  }

  scope :in_categories, lambda { |categories|
    {
      :joins => 'JOIN project_categories_projects ON properties.id = project_categories_projects.project_id',
      :conditions => ['project_category_id IN (?)', categories]
    }
  }

  scope :order_by_completion_date, :order => 'completion_date DESC'

  scope :featured_mobile, :conditions => { :featured_mobile => true }


  default_scope :order => 'title ASC'

  def related_projects(limit = 4)
    self.class.
      in_section(section).
      in_categories(project_category_ids).
      limit(limit).
      all(
        :select     => 'DISTINCT properties.id, properties.*',
        :conditions => ['properties.id != ?', id],
        :order      => 'properties.position ASC'
      )
  end

  def short_description
    read_attribute(:short_description).presence ||
      project_categories.first(2).map(&:title).join(' / ')
  end
end
