class County < ActiveRecord::Base

  belongs_to :state

  has_and_belongs_to_many :cities

  has_many :apartment_communities
  has_many :home_communities

  validates_presence_of :name, :state
  validates_uniqueness_of :name, :scope => :state_id

  scope :ordered_by_name, -> { order(name: :asc) }

  def to_s
    "#{name}, #{state.code}"
  end
  alias :typus_name :to_s
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
