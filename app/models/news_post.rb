class NewsPost < ActiveRecord::Base
  belongs_to :section

  named_scope :published, :conditions => { :published => true }

  validates_presence_of :title, :body, :section
  validates_inclusion_of :published, :in => [true, false]
end
