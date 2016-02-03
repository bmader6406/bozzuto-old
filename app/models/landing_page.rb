class LandingPage < ActiveRecord::Base
  include Bozzuto::Publishable
  extend FriendlyId

  has_and_belongs_to_many :apartment_communities

  has_and_belongs_to_many :home_communities

  has_and_belongs_to_many :featured_apartment_communities,
    :association_foreign_key => :apartment_community_id,
    :class_name              => 'ApartmentCommunity',
    :join_table              => :featured_apartment_communities_landing_pages

  has_many :popular_property_orderings, -> { includes(:property).order('position ASC, RAND(NOW())') },
    :class_name => 'LandingPagePopularOrdering',
    :dependent  => :destroy

  has_many :popular_properties, -> { order('landing_page_popular_orderings.position ASC, RAND(NOW())') },
    :class_name => 'Property',
    :through    => :popular_property_orderings,
    :source     => :property

  has_and_belongs_to_many :projects

  belongs_to :state
  belongs_to :promo
  belongs_to :local_info_feed, :class_name => 'Feed'

  after_save :set_positions_of_popular_properties

  validates_presence_of :title, :state
  validates_uniqueness_of :title

  scope :visible_for_list, -> { where(hide_from_list: false) }

  friendly_id :title, use: [:slugged, :history]

  has_attached_file :masthead_image,
    :url             => '/system/:class/:id/masthead_:style.:extension',
    :styles          => { :resized => '230x223#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  def typus_name
    title
  end

  protected

  def set_positions_of_popular_properties
    if custom_sort_popular_properties_changed?
      if custom_sort_popular_properties?
        popular_property_orderings.each_with_index { |ordering, position|
          ordering.insert_at(position + 1)
        }
      else
        popular_property_orderings.each { |ordering|
          ordering.update_attribute(:position, nil)
        }
      end
    end
  end
end
