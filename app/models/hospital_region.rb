class HospitalRegion < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :name, use: [:slugged]

  has_many :hospitals,      :dependent => :destroy
  has_one  :hospital_blog,  :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_numericality_of :latitude, :greater_than_or_equal_to => -90.0,
                                       :less_than_or_equal_to    => 90.0,
                                       :allow_nil                => true

  validates_numericality_of :longitude, :greater_than_or_equal_to => -180.0,
                                        :less_than_or_equal_to    => 180.0,
                                        :allow_nil                => true

  def communities
    children.map { |c| c.apartment_communities.published}.flatten.uniq
  end

  def parent
    nil
  end

  def children
    hospitals
  end

  def lineage
    if parent
      parent.lineage + [self]
    else
      [self]
    end
  end

  def full_name
    "#{name}" #Medical Residency Apartments"
  end

  def region_name
    "#{name} Medical Residency Apartments"
  end

  def to_s
    name
  end
end
