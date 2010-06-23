class Award < ActiveRecord::Base
  belongs_to :section

  validates_presence_of :title
  validates_inclusion_of :published, :in => [true, false]

  named_scope :published, :conditions => { :published => true }
end
