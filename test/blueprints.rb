require 'machinist/active_record'
require 'sham'

Sham.define do
  city             { Faker::Address.city }
  us_state_code    { |i| "%2s" % i.to_s(36) }
  us_state         { |i| "#{Faker::Address.us_state} #{i}" }
  company_name     { Faker::Company.name }
  feed_url         { |i| "http://#{i}.#{Faker::Internet.domain_name}/feed.rss" }
  section_title    { |i| "#{Faker::Lorem.words} #{i}" }
  file_name        { |i| "/image#{i}.jpg" }
  unique_name      { |i| "#{Faker::Lorem.words(2)} #{i}" }
  vaultware_id     { |i| i }
  property_link_id { |i| i }
end

Sham.bedrooms(:unique => false)  { rand(5) + 1 }
Sham.bathrooms(:unique => false) { (rand * 3).round_with_precision(1) + 1 }


ApartmentCommunity.blueprint do
  title             { Sham.company_name }
  subtitle          { Faker::Company.catch_phrase }
  use_market_prices { false }
  published         { true }
  phone_number      { Faker::PhoneNumber.phone_number }
  city
end

ApartmentCommunity.blueprint(:unpublished) do
  published { false }
end

ApartmentCommunity.blueprint(:vaultware) do
  external_cms_id   { Sham.vaultware_id }
  external_cms_type { 'vaultware' }
end

ApartmentCommunity.blueprint(:property_link) do
  external_cms_id   { Sham.property_link_id }
  external_cms_type { 'property_link' }
end

ApartmentFloorPlan.blueprint do
  name               { Faker::Lorem.words(1) }
  image_type         { ApartmentFloorPlan::USE_IMAGE_URL }
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
  floor_plan_group   { ApartmentFloorPlanGroup.studio }
  apartment_community
end

ApartmentFloorPlan.blueprint(:vaultware) do
  external_cms_id   { Sham.vaultware_id }
  external_cms_type { 'vaultware' }
end

ApartmentFloorPlan.blueprint(:property_link) do
  external_cms_id   { Sham.property_link_id }
  external_cms_type { 'property_link' }
end

ApartmentFloorPlanGroup.blueprint do; end

ApartmentFloorPlanGroup.blueprint(:studio) do
  name { 'Studio' }
end

ApartmentFloorPlanGroup.blueprint(:one_bedroom) do
  name { '1 Bedroom' }
end

ApartmentFloorPlanGroup.blueprint(:two_bedroom) do
  name { '2 Bedrooms' }
end

ApartmentFloorPlanGroup.blueprint(:three_bedroom) do
  name { '3 or More Bedrooms' }
end

ApartmentFloorPlanGroup.blueprint(:penthouse) do
  name { 'Penthouse' }
end

Award.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs }
  published    { true }
  published_at { Time.now }
end

Award.blueprint(:unpublished) do
  published    { false }
  published_at { nil }
end

Buzz.blueprint do
  email        { Faker::Internet.email }
  affiliations { '' }
  buzzes       { '' }
end

City.blueprint do
  name { Sham.city }
  state
end

ContactSubmission.blueprint do
  name    { Faker::Name.name }
  email   { Faker::Internet.email }
  message { Faker::Lorem.paragraphs }
  topic   { ContactTopic.make }
end

ContactTopic.blueprint do
  topic      { Sham.unique_name }
  body       { Faker::Lorem.paragraphs }
  recipients { Faker::Internet.email }
end

County.blueprint do
  name { Sham.city }
  state
end

DnrConfiguration.blueprint do
  customer_code { (rand(3000) + 500).to_s }
  campaign      { (rand(3000) + 500).to_s }
  ad_source     { (rand(500000) + 40000).to_s }
end

DnrReferrer.blueprint do
  domain_name { Faker::Internet.domain_name }
end

Feed.blueprint do
  name { Sham.unique_name }
  url  { Sham.feed_url }
end

FeedItem.blueprint do
  title        { Faker::Lorem.sentence }
  url          { Faker::Internet.domain_name }
  description  { Faker::Lorem.paragraphs }
  published_at { Time.now }
  feed
end

Lead2LeaseSubmission.blueprint do
  first_name    { Faker::Name.first_name }
  last_name     { Faker::Name.last_name }
  primary_phone { Faker::PhoneNumber.phone_number }
  email         { Faker::Internet.email }
  move_in_date  { Date.today }
  comments      { '' }
end

Home.blueprint do
  name      { Faker::Lorem.words(3) }
  bedrooms  { Sham.bedrooms }
  bathrooms { Sham.bathrooms }
  home_community
end

HomeCommunity.blueprint do
  title        { Sham.company_name }
  subtitle     { Faker::Company.catch_phrase }
  published    { true }
  phone_number { Faker::PhoneNumber.phone_number }
  city
end

HomeCommunity.blueprint(:unpublished) do
  published { false }
end

LandingPage.blueprint do
  title { Faker::Lorem.words(3) }
  state
  published { true }
end

LassoAccount.blueprint do
  uid          { '123' }
  client_id    { '456' }
  project_id   { '789' }
  analytics_id { 'LAS-123456' }
  property     { HomeCommunity.make }
end

NewsPost.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs(2) }
  published    { true }
  published_at { Time.now - 1.day }
end

NewsPost.blueprint(:unpublished) do
  published    { false }
  published_at { nil }
end

Photo.blueprint do
  title           { Faker::Lorem.words(3) }
  flickr_photo_id { (rand(50000000) + 50000000).to_s }
end

PhotoGroup.blueprint do
  title            { Faker::Lorem.words(3) }
  flickr_raw_title { Faker::Lorem.words(1) }
end

PhotoSet.blueprint do
  title             { Faker::Lorem.words(3) }
  flickr_set_number { (rand(50000000) + 50000000).to_s }
end

PressRelease.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs(2) }
  published    { true }
  published_at { Time.now - 1.day }
end

Project.blueprint do
  title           { Sham.company_name }
  subtitle        { Faker::Company.catch_phrase }
  published       { true }
  completion_date { Time.now + (rand(10)).days }
  city
end

Project.blueprint(:unpublished) do
  published { false }
end

ProjectCategory.blueprint do
  title { Sham.section_title }
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

Promo.blueprint do
  title               { Sham.unique_name }
  subtitle            { Sham.unique_name }
  has_expiration_date { false }
end

Promo.blueprint(:active) do
  has_expiration_date { true }
  expiration_date     { Time.now + 1.day }
end

Promo.blueprint(:expired) do
  has_expiration_date { true }
  expiration_date     { Time.now - 1.day }
end

Property.blueprint do
  title { Sham.company_name }
  city
end

PropertyFeature.blueprint do
  icon_file_name { Sham.file_name }
  name           { Sham.unique_name }
  description    { Faker::Lorem.paragraphs(1) }
end

PropertyContactPage.blueprint do
  property
  content       { Faker::Lorem.paragraphs(2) }
  meta_title    { Faker::Lorem.words(4) }
  meta_keywords { Faker::Lorem.words(6) }
end

PropertyFeaturesPage.blueprint do
  property
  text_1        { Faker::Lorem.paragraphs(2) }
  title_1       { Faker::Lorem.words(5) }
  text_2        { Faker::Lorem.paragraph }
  title_2       { Faker::Lorem.words(5) }
  meta_title    { Faker::Lorem.words(4) }
  meta_keywords { Faker::Lorem.words(6) }
end

PropertyNeighborhoodPage.blueprint do
  property
  content       { Faker::Lorem.paragraphs(2) }
  meta_title    { Faker::Lorem.words(4) }
  meta_keywords { Faker::Lorem.words(6) }
end

PropertyToursPage.blueprint do
  property
  title         { Faker::Lorem.words(3) }
  content       { Faker::Lorem.paragraphs(2) }
  meta_title    { Faker::Lorem.words(4) }
  meta_keywords { Faker::Lorem.words(6) }
end

Page.blueprint do
  title     { Faker::Lorem.sentence }
  body      { Faker::Lorem.paragraphs(3) }
  published { true }
  section
end

RecurringEmail.blueprint do
  email_address { Faker::Internet.email }
  recurring     { false }
end

RecurringEmail.blueprint(:recurring) do
  recurring { true }
end

Section.blueprint do
  title { Sham.section_title }
  service { false }
end

Section.blueprint(:service) do
  service { true }
end

Section.blueprint(:about) do
  title { 'About Us' }
  about { true }
end

Section.blueprint(:news_and_press) do
  title { 'News & Press' }
  about { true }
end

Snippet.blueprint do
  name { Sham.unique_name }
  body { Faker::Lorem.paragraphs }
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

Tweet.blueprint do
  text      { Faker::Lorem.sentence }
  posted_at { Time.now }
  tweet_id  { ActiveSupport::SecureRandom.hex }
  twitter_account
end

TwitterAccount.blueprint do
  username { 'TheBozzutoGroup' }
end

TypusUser.blueprint do
  email                 { Faker::Internet.email }
  role                  { 'admin' }
  password              { 'password' }
  password_confirmation { 'password' }
  status                { true }
  preferences           { { :locale => 'en' } }
end

UnderConstructionLead.blueprint do
  first_name   { Faker::Name.first_name }
  last_name    { Faker::Name.last_name }
  phone_number { Faker::PhoneNumber.phone_number }
  email        { Faker::Internet.email }
end

Video.blueprint do
  property
  url { "http://#{Faker::Internet.domain_name}/my_video" }
end
