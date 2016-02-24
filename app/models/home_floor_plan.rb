class HomeFloorPlan < ActiveRecord::Base

  acts_as_list :scope => :home

  belongs_to :home

  validates_presence_of :name

  has_attached_file :image,
    :url             => '/system/:class/:id/:style.:extension',
    :styles          => { :thumb => '160' },
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  do_not_validate_attachment_file_type :image

  def actual_image
    image.url
  end

  def actual_thumb
    image.url(:thumb)
  end

  def to_s
    name
  end

  def typus_name
    to_s
  end
end
