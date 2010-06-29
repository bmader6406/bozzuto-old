class Photo < ActiveRecord::Base
  belongs_to :apartment_community

  validates_presence_of :image, :caption, :apartment_community
end
