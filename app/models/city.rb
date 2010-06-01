class City < ActiveRecord::Base
  has_many :communities
  belongs_to :state

  validates_presence_of :name, :state
  validates_uniqueness_of :name, :scope => :state_id

  def to_s
    "#{name}, #{state.code}"
  end
end
