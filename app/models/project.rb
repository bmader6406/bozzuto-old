class Project < ActiveRecord::Base
  include Bozzuto::Model::Property
  
  acts_as_list scope: :section

  has_many :data_points, -> { order(position: :asc) },      class_name: 'ProjectDataPoint'
  has_many :updates,     -> { order(published_at: :desc) }, class_name: 'ProjectUpdate'

  belongs_to :section

  has_and_belongs_to_many :project_categories,
    -> { order(position: :asc) },
    join_table:  :project_categories_projects,
    foreign_key: :project_id

  validates_presence_of :completion_date

  validates_length_of :short_description, maximum: 40, allow_nil: true

  scope :in_section,               -> (section) { where(section_id: section.id) }
  scope :order_by_completion_date, -> { order(completion_date: :desc) }
  scope :featured_mobile,          -> { where(featured_mobile: true) }

  scope :in_categories, -> (category_ids) { joins(:project_categories).where(project_categories: { id: category_ids }) }

  friendly_id :title, use: :history

  def related_projects(limit = 4)
    self.class.
      in_section(section).
      in_categories(project_category_ids).
      select('DISTINCT projects.id', 'projects.*').
      where('projects.id != ?', id).
      order('projects.position ASC').
      limit(limit)
  end

  def short_description
    read_attribute(:short_description).presence ||
      project_categories.order(:id).first(2).map(&:title).join(' / ')
  end
end
