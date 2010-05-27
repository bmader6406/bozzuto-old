class State < ActiveRecord::Base
  has_many :cities

  validates_presence_of :code, :name
  validates_length_of :code, :is => 2
end
