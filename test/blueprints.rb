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

Sham.bedrooms(:unique => false)  { rand(5) + 1 }
Sham.bathrooms(:unique => false) { (rand * 3).round_with_precision(1) + 1 }


ApartmentCommunity.blueprint do
  title             { Sham.company_name }
  subtitle          { Faker::Company.catch_phrase }
  use_market_prices { false }
  city
end

Award.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs }
  published    { true }
  published_at { Time.now }
  section
end

Award.blueprint(:unpublished) do
  published    { false }
  published_at { nil }
end

City.blueprint do
  name { Sham.city }
  state
end

ContactSubmission.blueprint do
  name    { Faker::Name.name }
  email   { Faker::Internet.email }
  topic   { ContactSubmission::TOPICS.rand[1] }
  message { Faker::Lorem.paragraphs }
end

County.blueprint do
  name { Sham.city }
  state
end

FloorPlanGroup.blueprint do
  name { Faker::Lorem.words(1) }
end

FloorPlan.blueprint do
  name               { Faker::Lorem.words(1) }
  image_type         { FloorPlan::USE_IMAGE_URL }
  image_url          { Faker::Lorem.words(1) }
  availability_url   { "http://#{Faker::Internet.domain_name}" }
  bedrooms           { Sham.bedrooms }
  bathrooms          { Sham.bathrooms }
  min_square_feet    { rand(3000) + 500 }
  max_square_feet    { rand(3000) + 500 }
  min_market_rent    { rand(500000) + 40000 }
  max_market_rent    { rand(500000) + 40000 }
  min_effective_rent { rand(500000) + 40000 }
  max_effective_rent { rand(500000) + 40000 }
  floor_plan_group
  apartment_community
end

Home.blueprint do
  name      { Faker::Lorem.words(3) }
  bedrooms  { Sham.bedrooms }
  bathrooms { Sham.bathrooms }
  home_community
end

HomeCommunity.blueprint do
  title             { Sham.company_name }
  subtitle          { Faker::Company.catch_phrase }
  city
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

Project.blueprint do
  title    { Sham.company_name }
  subtitle { Faker::Company.catch_phrase }
  city
end

ProjectDataPoint.blueprint do
  name { Faker::Lorem.words(1) }
  data { Faker::Lorem.sentence }
  project
end

ProjectUpdate.blueprint do
  body         { Faker::Lorem.paragraphs(4) }
  published    { true }
  published_at { Time.now }
  project
end

Property.blueprint do
  title { Sham.company_name }
  city
end

Page.blueprint do
  title { Faker::Lorem.sentence }
  body  { Faker::Lorem.paragraphs(3) }
  section
end

Section.blueprint do
  title { Sham.section_title }
  service { false }
end

Section.blueprint(:service) do
  service { true }
end

Section.blueprint(:about) do
  title { 'About' }
end

State.blueprint do
  name { Sham.us_state }
  code { Sham.us_state_code }
end

Testimonial.blueprint do
  name  { Faker::Name.name }
  title { Faker::Lorem.sentence }
  quote { Faker::Lorem.paragraphs }
  section
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
