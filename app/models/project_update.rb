class ProjectUpdate < ActiveRecord::Base
  include Bozzuto::Publishable

  belongs_to :project

  default_scope :order => 'published_at DESC'

  validates_presence_of :body, :project
end
