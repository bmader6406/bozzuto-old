class CommunityPage < ActiveRecord::Base
  belongs_to :community

  acts_as_list :scope => :community

  validates_presence_of :title, :content, :community
end
