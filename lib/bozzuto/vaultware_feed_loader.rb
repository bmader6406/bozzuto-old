module Bozzuto
  class VaultwareFeedLoader < PropertyFeedLoader
    feed_type :vaultware

    NAMESPACE = {'ns' => 'http://my-company.com/namespace' }

    title                         './PropertyID/ns:Identification/ns:MarketingName', :namespace => NAMESPACE
    external_cms_id               './PropertyID/ns:Identification/ns:PrimaryID',     :namespace => NAMESPACE
    street_address                './PropertyID/ns:Address/ns:Address1',             :namespace => NAMESPACE
    state                         './PropertyID/ns:Address/ns:State',                :namespace => NAMESPACE
    city                          './PropertyID/ns:Address/ns:City',                 :namespace => NAMESPACE
    county                        './PropertyID/ns:Address/ns:CountyName',           :namespace => NAMESPACE
    availability_url              './Information/PropertyAvailabilityURL'

    floor_plan_name               './Name'
    floor_plan_comment            './Comment'
    floor_plan_availability_url   './FloorplanAvailabilityURL'
    floor_plan_bedroom_count      './Room[@Type="Bedroom"]/Count'
    floor_plan_bathroom_count     './Room[@Type="Bathroom"]/Count'

    floor_plan_min_square_feet    './SquareFeet',    :attribute => 'Min'
    floor_plan_max_square_feet    './SquareFeet',    :attribute => 'Max'
    floor_plan_min_market_rent    './MarketRent',    :attribute => 'Min'
    floor_plan_max_market_rent    './MarketRent',    :attribute => 'Max'
    floor_plan_min_effective_rent './EffectiveRent', :attribute => 'Min'
    floor_plan_max_effective_rent './EffectiveRent', :attribute => 'Max'
  end
end
