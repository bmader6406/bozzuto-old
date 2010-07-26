class MiniSlideshow < ActiveRecord::Base
  has_many :slides,
    :class_name => 'MiniSlide',
    :dependent  => :destroy,
    :order      => 'position ASC'

  has_one :home_page

  validates_presence_of :title, :link_url

  def typus_name
    title
  end
end
