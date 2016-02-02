class HomeFloorPlan < ActiveRecord::Base

  acts_as_list :scope => :home

  belongs_to :home

  default_scope -> { order(position: :asc) }

  validates_presence_of :name

  has_attached_file :image,
    :url             => '/system/:class/:id/:style.:extension',
    :styles          => { :thumb => '160' },
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  def actual_image
    image.url
  end

  def actual_thumb
    image.url(:thumb)
  end

  def typus_name
    name
  end
end
