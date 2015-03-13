class ApartmentUnitAmenity < ActiveRecord::Base
  PRIMARY_TYPE = [
    'Other',
    'AdditionalStorage',
    'AirConditioner',
    'Alarm',
    'Balcony',
    'Cable',
    'Carpet',
    'Carport',
    'CeilingFan',
    'ControlledAccess',
    'Courtyard',
    'DishWasher',
    'Disposal',
    'DoubleSinkVanity',
    'Dryer',
    'Fireplace',
    'FramedMirrors',
    'Furnished',
    'Garage',
    'Handrails',
    'HardwoodFlooring',
    'HardSurfaceCounterTops',
    'Heat',
    'IndividualClimateControl',
    'IslandKitchen',
    'LaminateCounterTops',
    'VinylFlooring',
    'LargeClosets',
    'LinenCloset',
    'Microwave',
    'Pantry',
    'Patio',
    'PrivateBalcony',
    'PrivatePatio',
    'Range',
    'Refrigerator',
    'Satellite',
    'Skylight',
    'TileFlooring',
    'VaultedCeiling',
    'View',
    'Washer',
    'WheelChair',
    'WD_Hookup',
    'WindowCoverings'
  ]

  SUB_TYPE = [
    'Central',
    'Window',
    'Wall',
    'Gas',
    'Gas or Electric',
    'Luxury',
    'Wood',
    'Electric',
    'Radiant',
    'Decorative',
    'Unspecified'
  ]

  belongs_to :apartment_unit

  validates :apartment_unit,
            :primary_type,
            :presence => true

  validates :primary_type, :inclusion => { :in => PRIMARY_TYPE }
  validates :sub_type,     :inclusion => { :in => SUB_TYPE }, :allow_nil => true
end
