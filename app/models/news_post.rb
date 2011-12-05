class NewsPost < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable

  cattr_reader :per_page
  @@per_page = 10

  has_and_belongs_to_many :sections
  
  default_scope :order => 'published_at DESC'

  validates_presence_of :title, :body

  has_attached_file :image,
    :url => '/system/:class/:id/:id_:style.:extension',
    :styles => { :thumb => '150x150#' },
    :default_style => :thumb

  def typus_name
    title
  end
end
