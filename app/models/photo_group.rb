class PhotoGroup < ActiveRecord::Base

  acts_as_list

  has_many :photos, -> { order('property_id ASC, photos.position ASC') },
           :dependent => :nullify

  scope :positioned, -> { order('photo_groups.position ASC') }

  validates :title,
            presence: true

  def to_s
    title
  end

  def to_label
    title
  end
end
