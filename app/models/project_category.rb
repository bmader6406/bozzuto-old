class ProjectCategory < ActiveRecord::Base
  acts_as_list

  has_friendly_id :title, :use_slug => true

  default_scope :order => 'position ASC'

  has_and_belongs_to_many :projects

  validates_presence_of :title
  validates_uniqueness_of :title

  def typus_name
    title
  end
end
