class Image < ActiveRecord::Base
  has_attached_file :image,
                    :url             => '/system/:class/:id/photo_:id_:style.:extension',
                    :styles          => { :resized => '870x375#', :thumb => '55x55#', :mobile => '300>' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :image, presence: true

  delegate :url, to: :image
end
