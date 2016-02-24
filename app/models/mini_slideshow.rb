class MiniSlideshow < ActiveRecord::Base

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'MiniSlide',
    :dependent  => :destroy

  accepts_nested_attributes_for :slides, allow_destroy: true

  validates_presence_of :title, :link_url

  def to_s
    title
  end

  def typus_name
    to_s
  end
end
