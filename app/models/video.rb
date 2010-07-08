class Video < ActiveRecord::Base
  acts_as_list :scope => :community

  belongs_to :community, :class_name => 'Community'

  default_scope :order => 'position ASC'

  validates_presence_of :url

  has_attached_file :image,
    :url => '/system/:class/:id/video_:id_:style.:extension',
    :styles => { :thumb => '55x55#' },
    :default_style => :thumb
end
