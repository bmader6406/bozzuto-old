class MiniSlideshow < ActiveRecord::Base

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'MiniSlide',
    :dependent  => :destroy

  validates :title,
            :link_url,
            presence: true

  accepts_nested_attributes_for :slides, allow_destroy: true

  def to_s
    title
  end

  def to_label
    to_s
  end

  def diff_attributes
    Chronolog::DiffRepresentation.new(self, includes: :slides).attributes
  end
end
