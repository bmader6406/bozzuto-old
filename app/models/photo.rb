class Photo < ActiveRecord::Base
  acts_as_list :scope => :photo_set

  belongs_to :photo_set

  validates_presence_of :title, :flickr_photo_id

  default_scope :order => 'position ASC'

  has_attached_file :image,
    :url => '/system/:class/:id/photo_:id_:style.:extension',
    :styles => { :resized => '870x375#', :thumb => '55x55#' },
    :default_style => :resized
end
