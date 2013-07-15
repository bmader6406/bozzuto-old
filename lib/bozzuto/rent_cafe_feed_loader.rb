module Bozzuto
  class RentCafeFeedLoader < ExternalFeedLoader
    self.feed_type = :rent_cafe
    self.tmp_file  = Rails.root.join('tmp', 'rent_cafe')
    self.lock_file = Rails.root.join('tmp', 'rent_cafe.lock')

    title                         './Identification/MarketingName'
    external_cms_id               './Identification/PrimaryID'
    street_address                './Identification/Address/Address1'
    state                         './Identification/Address/State'
    city                          './Identification/Address/City'

    floor_plan_external_cms_id    './Floorplan', :attribute => 'id'
    floor_plan_name               './Name'
    floor_plan_available_units    './UnitsAvailable'
    floor_plan_bedroom_count      './Room[@type="bedroom"]/Count'
    floor_plan_bathroom_count     './Room[@type="bathroom"]/Count'

    floor_plan_min_square_feet    './SquareFeet',    :attribute => 'min'
    floor_plan_max_square_feet    './SquareFeet',    :attribute => 'max'
    floor_plan_min_market_rent    './MarketRent',    :attribute => 'min'
    floor_plan_max_market_rent    './MarketRent',    :attribute => 'max'
    floor_plan_min_effective_rent './EffectiveRent', :attribute => 'min'
    floor_plan_max_effective_rent './EffectiveRent', :attribute => 'max'

    office_hour_open_time         './OpenTime'
    office_hour_close_time        './CloseTime'
    office_hour_day               './Day'
  end
end
