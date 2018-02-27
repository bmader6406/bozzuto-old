class Hospital < ActiveRecord::Base
  extend  Bozzuto::Neighborhoods::ListingImage
  extend FriendlyId

  friendly_id :name, use: [:slugged]

  acts_as_list :scope => :hospital_region

  after_save :update_hospital_distance

  has_neighborhood_listing_image

  has_many :hospital_memberships, -> { order('hospital_memberships.distance ASC') },
                                      :inverse_of => :hospital,
                                      :dependent  => :destroy

  has_many :apartment_communities, :through => :hospital_memberships

  belongs_to :hospital_region

  accepts_nested_attributes_for :hospital_memberships, allow_destroy: true

  validates_presence_of :name,
                        :hospital_region,
                        :latitude,
                        :longitude

  validates_uniqueness_of :name

  validates_numericality_of :latitude, :greater_than_or_equal_to => -90.0,
                                       :less_than_or_equal_to    => 90.0,
                                       :allow_nil                => true

  validates_numericality_of :longitude, :greater_than_or_equal_to => -180.0,
                                        :less_than_or_equal_to    => 180.0,
                                        :allow_nil                => true

  scope :position_asc, -> { order(position: :asc) }

  def as_jmapping
    {
      :id                => id,
      :point             => jmapping_point,
      :category          => jmapping_category,
      :name              => Rack::Utils.escape_html(name),
      :communities_count => hospital_communities_count,
      :class_name        => 'Hospital'
    }
  end

  def hospital_communities_count
    children.length
  end

  def jmapping_point
    {
      :lat => latitude || nil,
      :lng => longitude || nil,
    }
  end

  def jmapping_category
    self.class.to_s
  end

  def has_communities?
    children.any?
  end

  def parent
    hospital_region
  end

  def children
    apartment_communities
  end

  def lineage
    if parent
      parent.lineage + [self]
    else
      [self]
    end
  end

  def lineage_hash
    keys = [:hospital_region, :hospital]

    Hash[keys.zip(lineage)].reject { |_, v| v.nil? }
  end

  private

  def update_hospital_distance
    if latitude_changed? || longitude_changed?
      hospital_memberships.map{|c| c.recalculate_distance}
    end
  end
end
