class State < ActiveRecord::Base
  has_many :cities
  has_many :counties
  has_many :apartment_communities, :through => :cities

  named_scope :ordered_by_name, :order => 'name ASC'

  validates_presence_of :code, :name
  validates_length_of :code, :is => 2
  validates_uniqueness_of :code, :name

  def to_param
    code
  end
end
