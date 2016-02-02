class RankCategory < ActiveRecord::Base

  acts_as_list :scope => :publication

  validates_presence_of :name

  belongs_to :publication

  has_many :ranks, -> { order(year: :desc) },
    :dependent => :destroy
end
