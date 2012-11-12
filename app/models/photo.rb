class Photo < ActiveRecord::Base
  acts_as_list :scope => :photo_set

  belongs_to :photo_set
  has_and_belongs_to_many :photo_groups

  validates_presence_of :title, :flickr_photo_id

  default_scope :order => 'photos.position ASC'

  named_scope :in_set, lambda { |set|
    { :conditions => { :photo_set_id => set.id } }
  }
  
  named_scope :for_mobile, { :include => :photo_groups, 
    :conditions => 'photo_groups.flickr_raw_title = "mobile"' }

  has_attached_file :image,
    :url             => '/system/:class/:id/photo_:id_:style.:extension',
    :styles          => { :resized => '870x375#', :thumb => '55x55#', :mobile => '300>' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }
end
