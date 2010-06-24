class Award < ActiveRecord::Base
  belongs_to :section

  validates_presence_of :title
  validates_inclusion_of :published, :in => [true, false]

  default_scope :order => 'published_at DESC'
  named_scope :published, :conditions => { :published => true }
end
