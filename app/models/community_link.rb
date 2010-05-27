class CommunityLink < ActiveRecord::Base
  belongs_to :community

  validates_presence_of :title, :url, :community
end
