class Project < Property
  has_many :data_points,
    :class_name => 'ProjectDataPoint',
    :order      => 'position ASC'
  belongs_to :section
end
