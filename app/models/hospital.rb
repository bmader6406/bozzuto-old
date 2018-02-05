class Hospital < ActiveRecord::Base
	extend  Bozzuto::Neighborhoods::ListingImage
	extend FriendlyId

	friendly_id :name, use: [:slugged]

	has_neighborhood_listing_image

	has_many :hospital_memberships, -> { order('hospital_memberships.position ASC') },
		:inverse_of => :hospital,
		:dependent  => :destroy

	has_many :apartment_communities, :through => :hospital_memberships

	belongs_to :hospital_region

	accepts_nested_attributes_for :hospital_memberships, allow_destroy: true

	scope :position_asc,          -> { order(position: :asc) }
end
