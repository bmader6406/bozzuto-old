class LandingPage < ActiveRecord::Base
  has_and_belongs_to_many :apartment_communities
  has_and_belongs_to_many :home_communities, :order => 'title ASC'
  has_and_belongs_to_many :featured_apartment_communities,
    :association_foreign_key => :apartment_community_id,
    :class_name => 'ApartmentCommunity',
    :join_table => :featured_apartment_communities_landing_pages
  has_and_belongs_to_many :popular_properties,
    :association_foreign_key => :property_id,
    :class_name => 'Property',
    :join_table => :landing_pages_popular_properties
  has_and_belongs_to_many :projects
  belongs_to :state

  validates_presence_of :title, :state
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  has_attached_file :masthead_image,
    :url => '/system/:class/:id/masthead_:style.:extension',
    :styles => { :resized => '230x223#' },
    :default_style => :resized


  def all_properties
    @all_properties ||= [apartment_communities, home_communities, featured_apartment_communities, popular_properties, projects].flatten.uniq
  end
end
