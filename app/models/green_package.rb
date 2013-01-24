class GreenPackage < ActiveRecord::Base
  attr_accessible :home_community,
                  :home_community_id,
                  :photo


  belongs_to :home_community

  has_many :green_package_items,
           :inverse_of => :green_package,
           :order      => 'position ASC',
           :dependent  => :destroy

  has_many :green_features,
           :through => :green_package_items,
           :order   => 'green_package_items.position ASC'


  has_attached_file :photo,
                    :url             => '/system/:class/:attachment/:id/:basename_:style.:extension',
                    :styles          => { :resized => '498x551#' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }

  validates_presence_of :home_community

  validates_attachment_presence :photo


  def home_community_title
    home_community.title
  end
end
