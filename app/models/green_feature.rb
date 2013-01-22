class GreenFeature < ActiveRecord::Base
  attr_accessible :title, :description, :photo

  validates_presence_of :title


  has_attached_file :photo,
                    :url             => '/system/:class/:attachment/:id/:basename_:style.:extension',
                    :styles          => { :resized => '170x170#' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }


  validates_attachment_presence :photo
end
