class BodySlideshow < ActiveRecord::Base
  belongs_to :page

  validates_presence_of :name
end
