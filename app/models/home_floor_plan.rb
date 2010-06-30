class HomeFloorPlan < ActiveRecord::Base
  acts_as_list :scope => :home

  belongs_to :home

  default_scope :order => 'position ASC'

  validates_presence_of :name

  has_attached_file :image,
    :url => '/system/:class/:id/:style.:extension'

  validates_attachment_presence :image
end
