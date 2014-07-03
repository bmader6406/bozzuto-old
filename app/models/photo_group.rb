class PhotoGroup < ActiveRecord::Base
  acts_as_list

  has_many :photos,
           :order     => 'property_id ASC, photos.position ASC',
           :dependent => :nullify

  named_scope :positioned, { :order => 'photo_groups.position ASC' }

  validates_presence_of :title

  def typus_name
    title
  end
end
