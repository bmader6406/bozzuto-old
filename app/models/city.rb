class City < ActiveRecord::Base
  has_many :communities
  belongs_to :state

  validates_presence_of :name, :state

  def to_s
    "#{name}, #{state.code}"
  end
end
