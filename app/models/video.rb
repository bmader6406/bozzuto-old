class Video < ActiveRecord::Base

  acts_as_list :scope => :property

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => :property_id
  belongs_to :home_community,      :foreign_key => :property_id

  validates :url,
            presence: true

  has_attached_file :image,
    :url             => '/system/:class/:id/video_:id_:style.:extension',
    :styles          => { :thumb => '55x55#' },
    :default_style   => :thumb,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  def to_s
    if property.present?
      "#{property.title} - Video ##{position}"
    else
      "Video ##{id}"
    end
  end

  def to_label
    to_s
  end
end
