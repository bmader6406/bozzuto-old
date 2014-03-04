class Area < ActiveRecord::Base
  extend Bozzuto::Neighborhoods::Place

  acts_as_list :scope => :metro

  has_many :neighborhoods,
           :order     => 'position ASC',
           :dependent => :destroy

  belongs_to :metro

  validates_presence_of :metro
end
