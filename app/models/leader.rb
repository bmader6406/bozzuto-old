class Leader < ActiveRecord::Base
  extend FriendlyId
  include Bozzuto::AlgoliaSiteSearch

  has_many :leaderships,
           :dependent  => :destroy,
           :inverse_of => :leader
  has_many :leadership_groups, through: :leaderships

  algolia_site_search do
    attribute :name, :title, :company, :bio
    has_many_attribute :leadership_groups, :name
  end

  validates :name,
            :title,
            :company,
            :bio,
            presence: true

  friendly_id :name, use: [:history]

  has_attached_file :image,
                    :url             => '/system/:class/:id/:style.:extension',
                    :styles          => {:rect => '230x220#'},
                    :default_style   => :rect,
                    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  def to_s
    name
  end

  def to_label
    to_s
  end

  def description
    bio
  end
end
