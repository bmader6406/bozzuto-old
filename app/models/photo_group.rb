class PhotoGroup < ActiveRecord::Base
  acts_as_list

  has_and_belongs_to_many :photos

  default_scope :order => 'position ASC'

  validates_presence_of :title, :flickr_raw_title
end
