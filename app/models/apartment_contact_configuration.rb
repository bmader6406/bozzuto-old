class ApartmentContactConfiguration < ActiveRecord::Base
  belongs_to :apartment_community

  validates_presence_of :apartment_community
end
