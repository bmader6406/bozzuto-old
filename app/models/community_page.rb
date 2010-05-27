class CommunityPage < ActiveRecord::Base
  belongs_to :community

  validates_presence_of :title, :content, :community
end
