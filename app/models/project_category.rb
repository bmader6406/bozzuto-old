class ProjectCategory < ActiveRecord::Base
  extend FriendlyId

  acts_as_list

  friendly_id :title, use: [:history]

  default_scope -> { order(position: :asc) }

  scope :position_asc, -> { order(position: :asc) }

  has_and_belongs_to_many :projects, join_table: :project_categories_projects

  validates_presence_of :title
  validates_uniqueness_of :title

  def to_s
    title
  end
end
