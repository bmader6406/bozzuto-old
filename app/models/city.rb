class City < ActiveRecord::Base
  has_many :apartment_communities
  has_many :home_communities
  has_many :communities
  belongs_to :state
  has_and_belongs_to_many :counties

  validates_presence_of :name, :state
  validates_uniqueness_of :name, :scope => :state_id

  named_scope :ordered_by_name, :order => 'name ASC'

  def to_s
    "#{name}, #{state.code}"
  end
  alias :typus_name :to_s
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
