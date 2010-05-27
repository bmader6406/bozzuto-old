class Photo < ActiveRecord::Base
  belongs_to :community

  validates_presence_of :image, :caption, :community

  mount_uploader :image, ImageUploader
end
