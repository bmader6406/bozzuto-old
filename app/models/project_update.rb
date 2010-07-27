class ProjectUpdate < ActiveRecord::Base
  include Bozzuto::Publishable

  cattr_reader :per_page
  @@per_page = 6

  belongs_to :project

  default_scope :order => 'published_at DESC'

  validates_presence_of :body, :project

  has_attached_file :image,
    :url => '/system/:class/:id/:class_:id_:style.:extension',
    :styles => { :resized => '484x214#' },
    :default_style => :resized
end
