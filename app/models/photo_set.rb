class PhotoSet < ActiveRecord::Base
  belongs_to :community, :class_name => 'Community'

  validates_presence_of :title, :flickr_set_id
end
