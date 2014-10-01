class CarouselPanel < ActiveRecord::Base
  acts_as_list :scope => :carousel

  belongs_to :carousel

  has_attached_file :image,
    :url             => '/system/:class/:id/slide_:id_:style.:extension',
    :styles          => { :resized => '245x210#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  validates_presence_of :carousel
  validates_presence_of :link_url
  validates_presence_of :heading, :if => proc { |panel| panel.caption.present? }
  validates_presence_of :caption, :if => proc { |panel| panel.heading.present? }

  def typus_name
    "#{carousel.name} - Panel ##{position}"
  end

  def thumbnail_tag
    %{<img src="#{image.url}" width="75">}.html_safe
  end
end
