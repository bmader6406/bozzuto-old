class HospitalMembership < ActiveRecord::Base
	belongs_to :hospital
	belongs_to :apartment_community
end
