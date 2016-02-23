class Project < Property
  extend FriendlyId
  
  acts_as_list :scope => :section

  has_many :data_points,
    -> { order(position: :asc) },
    :class_name => 'ProjectDataPoint'

  has_many :updates,
    -> { order(published_at: :desc) },
    :class_name => 'ProjectUpdate'

  belongs_to :section

  has_and_belongs_to_many :project_categories,
    -> { order(position: :asc) },
    join_table:  :project_categories_projects,
    foreign_key: :project_id

  validates_presence_of :completion_date
  validates_inclusion_of :has_completion_date, :in => [true, false]

  default_scope -> { order(title: :asc) }

  scope :in_section,               -> (section) { where(section_id: section.id) }
  scope :order_by_completion_date, -> { order(completion_date: :desc) }
  scope :featured_mobile,          -> { where(featured_mobile: true) }
  scope :position_asc,             -> { order(position: :asc) }

  scope :in_categories, -> (categories) {
    joins('JOIN project_categories_projects ON properties.id = project_categories_projects.project_id')
      .where('project_category_id IN (?)', categories)
  }

  def related_projects(limit = 4)
    self.class.
      in_section(section).
      in_categories(project_category_ids).
      select('DISTINCT properties.id', 'properties.*').
      where('properties.id != ?', id).
      order('properties.position ASC').
      limit(limit)
  end

  def short_description
    read_attribute(:short_description).presence ||
      project_categories.order(:id).first(2).map(&:title).join(' / ')
  end
end
