require 'machinist/active_record'
require 'sham'

City.blueprint do
  name { Faker::Address.city }
  state
end

State.blueprint do
  name { Faker::Address.us_state }
  code { Faker::Address.us_state_abbr }
end

Community.blueprint do
  title    { Faker::Company.name }
  subtitle { Faker::Company.catch_phrase }
  city
end

FloorPlanGroup.blueprint do
  name { Faker::Company.name }
  community
end

FloorPlan.blueprint do
  image       { Faker::Lorem.words(1) }
  category    { Faker::Lorem.words(2) }
  bedrooms    { rand(5) + 1 }
  bathrooms   { (rand * 3).round_with_precision(1) + 1 }
  square_feet { rand(3000) + 500 }
  price       { rand(500000) + 40000 }
  floor_plan_group
end
