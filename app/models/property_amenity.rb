class PropertyAmenity < ActiveRecord::Base
  PRIMARY_TYPE = [
    'Other',
    'Availability24Hours',
    'AccentWalls',
    'BasketballCourt',
    'Bilingual',
    'BoatDocks',
    'BusinessCenter',
    'CarWashArea',
    'ChildCare',
    'ClubDiscount',
    'ClubHouse',
    'ConferenceRoom',
    'Concierge',
    'CoverPark',
    'DoorAttendant',
    'FitnessCenter',
    'Elevator',
    'FreeWeights',
    'FurnishedAvailable',
    'GamingStations',
    'Garage',
    'Gate',
    'GroceryService',
    'GroupExcercise',
    'GuestRoom',
    'HighSpeed',
    'Housekeeping',
    'HouseSitting',
    'JoggingWalkingTrails',
    'LakeFront',
    'LakeAccess',
    'Laundry',
    'Library',
    'MealService',
    'MediaRoom',
    'MultiUseRoom',
    'NightPatrol',
    'OnSiteMaintenance',
    'OnSiteManagement',
    'PackageReceiving',
    'PerDiemAccepted',
    'Pool',
    'PlayGround',
    'Racquetball',
    'RecRoom',
    'Recycling',
    'Sauna',
    'ShortTermLease',
    'SmokeFree',
    'Spa',
    'StorageSpace',
    'Sundeck',
    'TennisCourt',
    'Transportation',
    'TVLounge',
    'ValetTrash',
    'Vintage',
    'VolleyballCourt',
    'WirelessInternet'
  ]

  SUB_TYPE = [
    'Attached',
    'Detached',
    'Both',
    'SameLevelParking'
  ]

  belongs_to :property

  validates :property,
            :primary_type,
            :presence => true

  validates :primary_type, :inclusion => { :in => PRIMARY_TYPE }
  validates :sub_type,     :inclusion => { :in => SUB_TYPE }, :allow_blank => true

  acts_as_list :scope => :property
end
