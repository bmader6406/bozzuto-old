class Project < Property
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

  named_scope :in_section, lambda { |section|
    { :conditions => { :section_id => section.id } }
  }
  named_scope :in_categories, lambda { |categories|
    {
      :joins => 'JOIN project_categories_projects ON properties.id = project_categories_projects.project_id',
      :conditions => ['project_category_id IN (?)', categories]
    }
  }
  named_scope :order_by_completion_date, :order => 'completion_date DESC'
  named_scope :limit, lambda { |limit|
    { :limit => limit }
  }

  def related_projects(limit = 4)
    self.class.in_section(section).in_categories(project_category_ids).order_by_completion_date.limit(limit).all(:select => 'DISTINCT properties.id, properties.*')
  end
end
