require 'machinist/active_record'
require 'sham'

Sham.define do
  city          { Faker::Address.city }
  us_state_code { |i| "%2s" % i.to_s(36) }
  us_state      { |i| "#{Faker::Address.us_state} #{i}" }
  company_name  { Faker::Company.name }
  feed_url      { |i| "http://#{i}.#{Faker::Internet.domain_name}/feed.rss" }
  section_title { |i| "#{Faker::Lorem.words} #{i}" }
end

City.blueprint do
  name { Sham.city }
  state
end

County.blueprint do
  name { Sham.city }
  state
end

State.blueprint do
  name { Sham.us_state }
  code { Sham.us_state_code }
end

Community.blueprint do
  title             { Sham.company_name }
  subtitle          { Faker::Company.catch_phrase }
  use_market_prices { false }
  city
end

FloorPlanGroup.blueprint do
  name { Faker::Lorem.words(1) }
  community
end

FloorPlan.blueprint do
  name               { Faker::Lorem.words(1) }
  availability_url   { "http://#{Faker::Internet.domain_name}" }
  image              { Faker::Lorem.words(1) }
  bedrooms           { rand(5) + 1 }
  bathrooms          { (rand * 3).round_with_precision(1) + 1 }
  min_square_feet    { rand(3000) + 500 }
  max_square_feet    { rand(3000) + 500 }
  min_market_rent    { rand(500000) + 40000 }
  max_market_rent    { rand(500000) + 40000 }
  min_effective_rent { rand(500000) + 40000 }
  max_effective_rent { rand(500000) + 40000 }
  floor_plan_group
end

YelpFeed.blueprint do
  url { Sham.feed_url }
end

YelpFeedItem.blueprint do
  title        { Faker::Lorem.sentence }
  url          { Faker::Internet.domain_name }
  description  { Faker::Lorem.paragraphs }
  published_at { Time.now }
  yelp_feed
end

Section.blueprint do
  title { Sham.section_title }
end

Service.blueprint do
  title { Sham.section_title }
  section
end

NewsPost.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs(2) }
  published    { true }
  published_at { Time.now - 1.day }
  section
end

NewsPost.blueprint(:unpublished) do
  published    { false }
  published_at { nil }
end

Testimonial.blueprint do
  name  { Faker::Name.name }
  title { Faker::Lorem.sentence }
  quote { Faker::Lorem.paragraphs}
  section
end
