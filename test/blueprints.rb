require 'machinist/active_record'
require 'sham'

Sham.define do
  city          { Faker::Address.city }
  us_state_code { |i| "%2s" % i.to_s(36) }
  us_state      { |i| "#{Faker::Address.us_state} #{i}" }
  company_name  { Faker::Company.name }
end

City.blueprint do
  name { Sham.city }
  state
end

State.blueprint do
  name { Sham.us_state }
  code { Sham.us_state_code }
end

Community.blueprint do
  title    { Sham.company_name }
  subtitle { Faker::Company.catch_phrase }
  city
end

FloorPlanGroup.blueprint do
  name { Faker::Lorem.words(1) }
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
