class Community < ActiveRecord::Base
  belongs_to :city
  has_many :photos
  has_many :pages, :class_name => "CommunityPage"
  has_many :links, :class_name => "CommunityLink"
  has_many :floor_plans

  validates_presence_of :title, :subtitle, :city

  mount_uploader :promo, ImageUploader
end
