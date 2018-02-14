class Tours360 < ActiveRecord::Base
	acts_as_list scope: :property

  belongs_to :property, polymorphic: true

  validates :url, presence: true

  has_attached_file :image,
    :url             => '/system/:class/:id/tours360_:id_:style.:extension',
    :styles          => { :thumb => '55x55#' },
    :default_style   => :thumb,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  def to_s
    if property.present?
      "#{property.title} - Tours360 ##{position}"
    else
      "Tours360 ##{id}"
    end
  end

  def to_label
    to_s
  end
end
