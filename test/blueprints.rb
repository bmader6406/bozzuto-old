require 'machinist/active_record'
require 'sham'

Community.blueprint do
  title { Faker::Company.name }
  subtitle { Faker::Company.catch_phrase }
  city
end

City.blueprint do
  name { Faker::Address.city }
  state
end

State.blueprint do
  name { Faker::Address.us_state }
  code { Faker::Address.us_state_abbr }
end
