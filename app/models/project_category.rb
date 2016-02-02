class ProjectCategory < ActiveRecord::Base
  include FriendlyId

  acts_as_list

  friendly_id :title, use: [:slugged]

  default_scope -> { order(position: :asc) }

  has_and_belongs_to_many :projects

  validates_presence_of :title
  validates_uniqueness_of :title

  def typus_name
    title
  end
end
