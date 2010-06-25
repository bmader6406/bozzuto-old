class ProjectUpdate < ActiveRecord::Base
  include Bozzuto::Publishable

  cattr_reader :per_page
  @@per_page = 6

  belongs_to :project

  default_scope :order => 'published_at DESC'

  validates_presence_of :body, :project
end
