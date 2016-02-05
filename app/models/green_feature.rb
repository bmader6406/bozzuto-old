class GreenFeature < ActiveRecord::Base
  attr_accessible :title, :description, :photo

  has_many :green_package_items,
           :inverse_of => :green_feature,
           :dependent  => :destroy

  validates_presence_of :title


  has_attached_file :photo,
                    :url             => '/system/:class/:attachment/:id/:basename_:style.:extension',
                    :styles          => { :resized => '170x170#' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }


  validates_attachment_presence :photo

  do_not_validate_attachment_file_type :photo

  def to_s
    title
  end
  alias_method :typus_name, :to_s
end
