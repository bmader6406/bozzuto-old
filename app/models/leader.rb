class Leader < ActiveRecord::Base
  acts_as_list :scope => :leadership_group

  belongs_to :leadership_group

  validates_presence_of :name, :title, :company, :leadership_group, :bio

  has_attached_file :image,
                    :url           => '/system/:class/:id/:style.:extension',
                    :styles        => {:rect => '230x220#'},
                    :default_style => :rect
end
