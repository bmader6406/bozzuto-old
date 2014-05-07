class Leadership < ActiveRecord::Base
  acts_as_list :scope => :leadership_group


  belongs_to :leader,
             :inverse_of => :leaderships

  belongs_to :leadership_group,
             :inverse_of => :leaderships


  validates_presence_of :leader, :leadership_group

  delegate :name, :to => :leader
end
