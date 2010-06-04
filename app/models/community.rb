class Community < ActiveRecord::Base
  belongs_to :city
  has_many :photos
  has_many :floor_plan_groups
  has_many :floor_plans, :through => :floor_plan_groups

  validates_presence_of :title, :subtitle, :city

  mount_uploader :promo_image, ImageUploader

  def address
    [street_address, city].compact.join(', ')
  end
end
