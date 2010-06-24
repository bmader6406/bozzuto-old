class Award < ActiveRecord::Base
  include Bozzuto::Publishable

  belongs_to :section

  default_scope :order => 'published_at DESC'

  validates_presence_of :title
end
