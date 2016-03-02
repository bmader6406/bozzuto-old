class CarouselPanel < ActiveRecord::Base

  acts_as_list :scope => :carousel

  belongs_to :carousel

  has_attached_file :image,
    :url             => '/system/:class/:id/slide_:id_:style.:extension',
    :styles          => { :resized => '245x210#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  validates_attachment_presence :image

  do_not_validate_attachment_file_type :image

  validates :carousel,
            :link_url,
            presence: true

  validates :heading,
            presence: true,
            if:       ->(panel) { panel.caption.present? }

  validates :caption,
            presence: true,
            if:       ->(panel) { panel.heading.present? }

  def to_s
    "#{carousel.name} - Panel ##{position}"
  end

  def to_label
    to_s
  end

  def thumbnail_tag
    %{<img src="#{image.url}" width="75">}.html_safe
  end
end
