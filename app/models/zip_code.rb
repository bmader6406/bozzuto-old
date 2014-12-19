class ZipCode < ActiveRecord::Base
  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  validates :zip, :latitude, :longitude, presence: true

  validates :zip, uniqueness: true
end
