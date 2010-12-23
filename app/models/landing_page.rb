class LandingPage < ActiveRecord::Base
  has_and_belongs_to_many :apartment_communities
  has_and_belongs_to_many :home_communities, :order => 'title ASC'
  has_and_belongs_to_many :featured_apartment_communities,
    :association_foreign_key => :apartment_community_id,
    :class_name => 'ApartmentCommunity',
    :join_table => :featured_apartment_communities_landing_pages
  has_many :popular_properties, :class_name => 'LandingPagePopularProperty',
    :order => 'position ASC, RAND(NOW())', :include => :property
  has_and_belongs_to_many :projects
  belongs_to :state
  belongs_to :promo
  
  after_save :set_positions_of_popular_properties

  validates_presence_of :title, :state
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  has_attached_file :masthead_image,
    :url => '/system/:class/:id/masthead_:style.:extension',
    :styles => { :resized => '230x223#' },
    :default_style => :resized


  def all_properties
    @all_properties ||= [apartment_communities, home_communities, 
      featured_apartment_communities, popular_properties.map(&:property),
      projects].flatten.uniq
  end
  
  protected
  
  def set_positions_of_popular_properties
    if custom_sort_popular_properties_changed?
      if custom_sort_popular_properties?
        popular_properties.each do |property|
          property.insert_at
        end
      else
        popular_properties.each do |property|
          property.update_attribute(:position, nil)
        end
      end
    end
  end
end
