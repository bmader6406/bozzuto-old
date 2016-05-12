class ProjectDataPoint < ActiveRecord::Base
  acts_as_list scope: :project

  belongs_to :project

  scope :position_asc, -> { order(position: :asc) }

  validates_presence_of :name, :data, :project
end
