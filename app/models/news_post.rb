class NewsPost < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
  
  belongs_to :section

  validates_presence_of :title, :body, :section
  validates_inclusion_of :published, :in => [true, false]

  named_scope :published, :conditions => { :published => true }
  named_scope :recent, lambda { |limit|
    { :limit => limit }
  }
end
