class Photo < ActiveRecord::Base
  acts_as_list :scope => :photo_set

  belongs_to :photo_set
  has_and_belongs_to_many :photo_groups

  validates_presence_of :title, :flickr_photo_id

  default_scope :order => 'position ASC'

  named_scope :in_set, lambda { |set|
    { :conditions => { :photo_set_id => set.id } }
  }

  has_attached_file :image,
    :url => '/system/:class/:id/photo_:id_:style.:extension',
    :styles => { :resized => '870x375#', :thumb => '55x55#' },
    :default_style => :resized
end
