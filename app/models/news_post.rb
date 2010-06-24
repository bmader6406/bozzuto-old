class NewsPost < ActiveRecord::Base
  include Bozzuto::Publishable

  cattr_reader :per_page
  @@per_page = 10
  
  belongs_to :section

  default_scope :order => 'published_at DESC'

  validates_presence_of :title, :body, :section
end
