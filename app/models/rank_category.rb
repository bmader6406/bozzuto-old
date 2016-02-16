class RankCategory < ActiveRecord::Base

  acts_as_list :scope => :publication

  belongs_to :publication

  has_many :ranks, -> { order(year: :desc) },
    :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :publication
end
