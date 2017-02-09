class Publication < ActiveRecord::Base
  include Bozzuto::Publishable

  acts_as_list

  has_many :rank_categories, -> { order(position: :asc) },
    :dependent => :destroy

  scope :ordered, -> { order(position: :asc) }

  validates :name,
            presence: true

  has_attached_file :image,
    :url             => '/system/:class/:id/publication_:id_:style.:extension',
    :styles          => { :resized => '110' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }


  validates_attachment_presence :image

  do_not_validate_attachment_file_type :image

  def to_s
    name
  end

  def to_label
    name
  end
end
