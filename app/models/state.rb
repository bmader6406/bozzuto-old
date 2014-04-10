class State < ActiveRecord::Base
  extend Bozzuto::Seo

  acts_as_list

  has_many :cities
  has_many :counties

  has_many :home_communities,
           :through => :cities

  has_many :apartment_communities,
           :through => :cities

  has_many :communities,
           :through => :cities

  has_many :featured_apartment_communities,
           :through    => :cities,
           :conditions => { :featured => true },
           :class_name => 'ApartmentCommunity',
           :source     => :apartment_communities,
           :order      => 'featured_position'

  has_many :neighborhoods
  has_many :areas

  named_scope :ordered_by_name, :order => 'states.name ASC'
  named_scope :positioned,      :order => 'states.position ASC'

  validates_presence_of :code, :name
  validates_length_of :code, :is => 2
  validates_uniqueness_of :code, :name

  def to_param
    code
  end

  def to_s
    name
  end

  def places(reload = false)
    @places = nil if reload

    @places ||= (neighborhoods + areas.showing_communities).sort_by(&:apartment_communities_count).reverse
  end
end
