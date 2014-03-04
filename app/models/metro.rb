class Metro < ActiveRecord::Base
  extend Bozzuto::Neighborhoods::Place

  acts_as_list

  has_many :areas,
           :order     => 'position ASC',
           :dependent => :destroy
end
