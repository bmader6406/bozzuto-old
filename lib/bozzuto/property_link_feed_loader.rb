module Bozzuto
  class PropertyLinkFeedLoader < ExternalFeedLoader
    self.feed_type = :property_link
    self.tmp_file  = Rails.root.join('tmp', 'property_link')
    self.lock_file = Rails.root.join('tmp', 'property_link.lock')

    title                         './PropertyID/Identification/MarketingName'
    external_cms_id               './PropertyID/Identification/PrimaryID'
    street_address                './PropertyID/Address/Address1'
    state                         './PropertyID/Address/State'
    city                          './PropertyID/Address/City'

    floor_plan_name               './Name'
    floor_plan_available_units    './DisplayedUnitsAvailable'
    floor_plan_bedroom_count      './Room[@Type="Bedroom"]/Count'
    floor_plan_bathroom_count     './Room[@Type="Bathroom"]/Count'

    floor_plan_min_square_feet    './SquareFeet',    :attribute => 'Min'
    floor_plan_max_square_feet    './SquareFeet',    :attribute => 'Max'
    floor_plan_min_market_rent    './MarketRent',    :attribute => 'Min'
    floor_plan_max_market_rent    './MarketRent',    :attribute => 'Max'
    floor_plan_min_effective_rent './EffectiveRent', :attribute => 'Min'
    floor_plan_max_effective_rent './EffectiveRent', :attribute => 'Max'

    office_hour_open_time         './OpenTime'
    office_hour_close_time        './CloseTime'
    office_hour_day               './Day'
  end
end
