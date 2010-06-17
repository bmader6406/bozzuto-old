class City < ActiveRecord::Base
  has_many :communities
  belongs_to :state
  belongs_to :county

  validates_presence_of :name, :state
  validates_uniqueness_of :name, :scope => :state_id

  named_scope :ordered_by_name, :order => 'name ASC'

  def to_s
    "#{name}, #{state.code}"
  end
  alias :typus_name :to_s
end
