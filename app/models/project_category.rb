class ProjectCategory < ActiveRecord::Base
  acts_as_list

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title
end
