class County < ActiveRecord::Base
  belongs_to :state
  has_many :cities
  has_many :apartment_communities, :through => :cities

  validates_presence_of :name, :state
  validates_uniqueness_of :name, :scope => :state_id

  named_scope :ordered_by_name, :order => 'name ASC'

  def to_s
    "#{name}, #{state.code}"
  end
  alias :typus_name :to_s
end
