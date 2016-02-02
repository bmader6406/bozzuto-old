class MiniSlideshow < ActiveRecord::Base

  has_many :slides, -> { order(position: :asc) },
    :class_name => 'MiniSlide',
    :dependent  => :destroy

  validates_presence_of :title, :link_url

  def typus_name
    title
  end
end
