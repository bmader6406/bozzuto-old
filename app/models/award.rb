class Award < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable

  cattr_reader :per_page
  @@per_page = 15

  default_scope :order => 'published_at DESC'

  has_and_belongs_to_many :sections

  validates_presence_of :title

  has_attached_file :image,
    :url => '/system/:class/:id/:class_:id_:style.:extension',
    :styles => { :thumb => '55x55#', :resized => '150x150#' },
    :default_style => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  def typus_name
    title
  end
end
