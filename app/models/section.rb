class Section < ActiveRecord::Base
  has_one :service, :order => 'position ASC'

  validates_presence_of :title
  validates_uniqueness_of :title
end
