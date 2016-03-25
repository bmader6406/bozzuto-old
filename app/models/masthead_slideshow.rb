class MastheadSlideshow < ActiveRecord::Base

  belongs_to :page

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'MastheadSlide',
    :dependent  => :destroy

  validates_presence_of :name

  def to_s
    name
  end

  def diff_attributes
    Chronolog::DiffRepresentation.new(self, includes: :slides).attributes
  end
end
