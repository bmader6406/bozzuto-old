class County < ActiveRecord::Base
  belongs_to :state
  has_many :cities

  validates_presence_of :name, :state
  validates_uniqueness_of :name, :scope => :state_id
end
