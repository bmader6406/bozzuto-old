class Publication < ActiveRecord::Base
  acts_as_list

  validates_presence_of :name

  has_attached_file :image,
    :url => '/system/:class/:id/publication_:id_:style.:extension'#,
    # :styles => { :resized => '840x375#' },
    # :default_style => :resized

  has_many :rank_categories,
    :order     => 'position ASC',
    :dependent => :destroy
end
