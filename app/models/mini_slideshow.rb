class MiniSlideshow < ActiveRecord::Base
  has_many :slides,
    :class_name => 'MiniSlide',
    :dependent  => :destroy,
    :order      => 'position ASC'

  validates_presence_of :title, :link_url

  def typus_name
    title
  end
end
