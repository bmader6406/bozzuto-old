class NewsPost < ActiveRecord::Base
  include Bozzuto::Publishable

  CATEGORY = ['Press Releases', 'Media Clips', 'Speeches']

  cattr_reader :per_page
  @@per_page = 10
  
  belongs_to :section

  default_scope :order => 'published_at DESC'

  validates_presence_of :title, :body, :section, :category

  has_attached_file :image,
    :url => '/system/:class/:id/:id_:style.:extension',
    :styles => { :thumb => '150x150#' },
    :default_style => :thumb
end
