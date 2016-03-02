class ProjectUpdate < ActiveRecord::Base
  include Bozzuto::Publishable

  cattr_reader :per_page
  @@per_page = 6

  belongs_to :project

  default_scope -> { order(published_at: :desc) }

  validates :project,
            :body,
            presence: true

  has_attached_file :image,
    :url             => '/system/:class/:id/:class_:id_:style.:extension',
    :styles          => { :resized => '484x214#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  def to_s
    "#{project.title} Update - #{published_at ? published_at.to_s(:month_day_year) : id}"
  end

  def to_label
    to_s
  end
end
