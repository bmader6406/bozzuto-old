class Video < ActiveRecord::Base
  acts_as_list :scope => :property

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => :property_id
  belongs_to :home_community,      :foreign_key => :property_id

  validates_presence_of :url

  has_attached_file :image,
    :url             => '/system/:class/:id/video_:id_:style.:extension',
    :styles          => { :thumb => '55x55#' },
    :default_style   => :thumb,
    :convert_options => { :all => '-quality 80 -strip' }

  def typus_name
    if property.present?
      "#{property.title} - Video ##{position}"
    else
      "Video ##{id}"
    end
  end
end
