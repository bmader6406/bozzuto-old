class PhotoGroup < ActiveRecord::Base
  COMMUNITY_JOIN_SQL = <<SQL
    photo_groups INNER JOIN (
      photo_groups_photos INNER JOIN photos
      ON photo_groups_photos.photo_id = photos.id)
    ON photo_groups.id = photo_groups_photos.photo_group_id
SQL

  acts_as_list

  has_and_belongs_to_many :photos

  default_scope :order => 'position ASC'

  validates_presence_of :title, :flickr_raw_title
  
  named_scope :for_community, lambda {|community|
    { :joins => COMMUNITY_JOIN_SQL, 
      :conditions => ["photos.photo_set_id = ? AND photo_groups.flickr_raw_title != ?", 
        community.photo_set.id, 'mobile'],
      :select => 'DISTINCT photo_groups.*' }
  }
end
