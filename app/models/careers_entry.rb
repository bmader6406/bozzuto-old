class CareersEntry < ActiveRecord::Base
  acts_as_list

  validates_presence_of :name,
                        :company,
                        :job_title,
                        :job_description

  has_attached_file :main_photo,
                    :url             => '/system/:class/:id/:basename_:style.:extension',
                    :convert_options => { :grayscale => '-colorspace Gray' },
                    :default_style   => :resized,
                    :styles          => {
                      :resized   => '212x350#',
                      :grayscale => '212x350#'
                    }

  has_attached_file :headshot,
                    :url           => '/system/:class/:id/:basename_:style.:extension',
                    :styles        => { :resized => '230x220#' },
                    :default_style => :resized


  validates_attachment_presence :main_photo
  validates_attachment_presence :headshot

  default_scope :order => 'position ASC'
end
