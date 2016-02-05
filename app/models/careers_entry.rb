class CareersEntry < ActiveRecord::Base

  acts_as_list

  default_scope -> { order(position: :asc) }

  validates_presence_of :name,
                        :company,
                        :job_title,
                        :job_description

  has_attached_file :main_photo,
                    :url             => '/system/:class/:attachment/:id/:basename_:style.:extension',
                    :convert_options => { 
                      :grayscale => '-colorspace Gray',
                      :all       => '-quality 80 -strip'
                    },
                    :default_style   => :resized,
                    :styles          => {
                      :resized   => '212x350#',
                      :grayscale => '212x350#'
                    }

  has_attached_file :headshot,
                    :url             => '/system/:class/:attachment/:id/:basename_:style.:extension',
                    :styles          => { :resized => '230x220#' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :main_photo
  validates_attachment_presence :headshot

  do_not_validate_attachment_file_type :main_photo
  do_not_validate_attachment_file_type :headshot

  def typus_name
    name
  end
end
