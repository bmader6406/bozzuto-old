class Project < Property
  has_many :data_points,
    :class_name => 'ProjectDataPoint',
    :order      => 'position ASC'
  has_many :updates,
    :class_name => 'ProjectUpdate',
    :order      => 'published_at DESC'
  belongs_to :section
  has_and_belongs_to_many :project_categories
end
