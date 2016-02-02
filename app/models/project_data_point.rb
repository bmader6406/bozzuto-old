class ProjectDataPoint < ActiveRecord::Base
  acts_as_list

  belongs_to :project

  default_scope -> { order(position: :asc) }

  validates_presence_of :name, :data, :project
end
