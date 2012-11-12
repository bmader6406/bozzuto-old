class Publication < ActiveRecord::Base
  include Bozzuto::Publishable

  acts_as_list

  validates_presence_of :name

  has_attached_file :image,
    :url             => '/system/:class/:id/publication_:id_:style.:extension',
    :styles          => { :resized => '110' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  has_many :rank_categories,
    :order     => 'position ASC',
    :dependent => :destroy

  named_scope :ordered, :order => 'position ASC'
end
