require 'machinist/active_record'
require 'sham'

Sham.define do
  us_state_code(:unique => false) do |i|
    i = i % (36*36)

    "%2s" % i.to_s(36)
  end

  city              { Faker::Address.city }
  us_state          { |i| "#{Faker::Address.us_state} #{i}" }
  company_name      { Faker::Company.name }
  feed_url          { |i| "http://#{i}.#{Faker::Internet.domain_name}/feed.rss" }
  section_title     { |i| "#{Faker::Lorem.words * ' '} #{i}" }
  file_name         { |i| "/image#{i}.jpg" }
  unique_name       { |i| "#{Faker::Lorem.words(2) * ' '} #{i}" }
  vaultware_id      { |i| i.to_s }
  property_link_id  { |i| i.to_s }
  rent_cafe_id      { |i| i.to_s }
  psi_id            { |i| i.to_s }
  metro_name        { |i| "Metro ##{i}" }
  area_name         { |i| "Area ##{i}" }
  neighborhood_name { |i| "Neighborhood ##{i}" }
  latitude          { |i| -90.0 + i/10.0 }
  longitude         { |i| -180.0 + i/10.0 }
end

Sham.bedrooms(:unique => false)  { rand(5) + 1 }
Sham.bathrooms(:unique => false) { (rand * 3).round(1) + 1 }


AdSource.blueprint do
  domain_name { Faker::Internet.domain_name }
  value       { 'Value' }
end

ApartmentCommunity.blueprint do
  title              { Sham.company_name }
  subtitle           { Faker::Company.catch_phrase }
  published          { true }
  included_in_export { true }
  phone_number       { Faker::PhoneNumber.phone_number }
  city
end

ApartmentCommunity.blueprint(:unpublished) do
  published { false }
end

ApartmentCommunity.blueprint(:excluded_from_export) do
  included_in_export { false }
end

ApartmentCommunity.blueprint(:vaultware) do
  external_cms_id   { Sham.vaultware_id }
  external_cms_type { 'vaultware' }
end

ApartmentCommunity.blueprint(:property_link) do
  external_cms_id   { Sham.property_link_id }
  external_cms_type { 'property_link' }
end

ApartmentCommunity.blueprint(:rent_cafe) do
  external_cms_id   { Sham.rent_cafe_id }
  external_cms_type { 'rent_cafe' }
end

ApartmentCommunity.blueprint(:psi) do
  external_cms_id   { Sham.psi_id }
  external_cms_type { 'psi' }
end

ApartmentFloorPlan.blueprint do
  name               { Faker::Lorem.words(1) * ' ' }
  image_type         { ApartmentFloorPlan::USE_IMAGE_URL }
  image_url          { Faker::Lorem.words(1) * ' ' }
  availability_url   { "http://#{Faker::Internet.domain_name}" }
  available_units    { 10 }
  bedrooms           { Sham.bedrooms }
  bathrooms          { Sham.bathrooms }
  min_square_feet    { rand(3000) + 500 }
  max_square_feet    { rand(3000) + 500 }
  min_rent           { rand(500000) + 40000 }
  max_rent           { rand(500000) + 40000 }
  floor_plan_group   { ApartmentFloorPlanGroup.studio.presence || ApartmentFloorPlanGroup.make(:studio) }
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

ApartmentFloorPlan.blueprint(:rent_cafe) do
  external_cms_id   { Sham.rent_cafe_id }
  external_cms_type { 'rent_cafe' }
end

ApartmentFloorPlan.blueprint(:psi) do
  external_cms_id   { Sham.psi_id }
  external_cms_type { 'psi' }
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

Area.blueprint do
  name                    { Sham.area_name }
  latitude                { Sham.latitude }
  longitude               { Sham.longitude }
  listing_image_file_name { Sham.file_name }
  area_type               { 'neighborhoods' }
  metro
end

Area.blueprint(:neighborhoods) do
  area_type { 'neighborhoods' }
end

Area.blueprint(:communities) do
  area_type { 'communities' }
end

AreaMembership.blueprint do
  area
  apartment_community
end

Award.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs * ' ' }
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

ContactSubmission.class_eval do
  def self.make_unsaved(attrs = {})
    new(attrs.reverse_merge(
      :name     => 'Bruce Wayne',
      :email    => Faker::Internet.email,
      :message  => Faker::Lorem.paragraphs * ' ',
      :topic_id => ContactTopic.make.id
    ))
  end
end

ContactTopic.blueprint do
  topic      { Sham.unique_name }
  body       { Faker::Lorem.paragraphs * ' ' }
  recipients { Faker::Internet.email }
end

County.blueprint do
  name { Sham.city }
  state
end

DnrConfiguration.blueprint do
  customer_code { (rand(3000) + 500).to_s }
end

Feed.blueprint do
  name { Sham.unique_name }
  url  { Sham.feed_url }
end

FeedItem.blueprint do
  title        { Faker::Lorem.sentence }
  url          { Faker::Internet.domain_name }
  description  { Faker::Lorem.paragraphs * ' ' }
  published_at { Time.now }
  feed
end

GreenFeature.blueprint do
  title              { Sham.unique_name }
  description        { Faker::Lorem.sentence }
  photo_file_name    { Sham.file_name }
  photo_content_type { 'text/jpg' }
end

GreenPackage.blueprint do
  photo_file_name    { Sham.file_name }
  photo_content_type { 'text/jpg' }
  home_community     { HomeCommunity.make }
  ten_year_old_cost  { rand(3000) + 500 }
end

GreenPackageItem.blueprint do
  savings     { rand(1000) + 30 }
  ultra_green { false }
  green_feature
  green_package
end

GreenPackageItem.blueprint(:ultra_green) do
  ultra_green { true }
end

Home.blueprint do
  name      { Faker::Lorem.words(3) * ' ' }
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

HomeFloorPlan.blueprint do
  home
  name            { Sham.company_name }
  image_file_name { Sham.file_name }
end

HomeCommunity.blueprint(:unpublished) do
  published { false }
end

HomeNeighborhood.blueprint do
  name                    { Sham.neighborhood_name }
  latitude                { Sham.latitude }
  longitude               { Sham.longitude }
  banner_image_file_name  { Sham.file_name }
  listing_image_file_name { Sham.file_name }
end

HomeNeighborhoodMembership.blueprint do
  home_neighborhood
  home_community
end

LandingPage.blueprint do
  title { Faker::Lorem.words(3) * ' ' }
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

Lead2LeaseSubmission.class_eval do
  def self.make_unsaved(attrs = {})
    new(attrs.reverse_merge(
      :first_name    => Faker::Name.first_name,
      :last_name     => Faker::Name.last_name,
      :primary_phone => Faker::PhoneNumber.phone_number,
      :email         => Faker::Internet.email,
      :move_in_date  => Date.today,
      :comments      => ''
    ))
  end
end

Leader.blueprint do
  name    { Faker::Name.name }
  title   { 'CEO' }
  company { Faker::Company.name }
  bio     { Faker::Lorem.paragraphs(2) * ' ' }
end

Metro.blueprint do
  name                    { Sham.metro_name }
  latitude                { Sham.latitude }
  longitude               { Sham.longitude }
  listing_image_file_name { Sham.file_name }
end

Neighborhood.blueprint do
  name                    { Sham.neighborhood_name }
  latitude                { Sham.latitude }
  longitude               { Sham.longitude }
  banner_image_file_name  { Sham.file_name }
  listing_image_file_name { Sham.file_name }
  area
  state
end

NeighborhoodMembership.blueprint do
  neighborhood
  apartment_community
end

NewsPost.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs(2) * ' ' }
  published    { true }
  published_at { Time.now - 1.day }
end

NewsPost.blueprint(:unpublished) do
  published    { false }
  published_at { nil }
end

Page.blueprint do
  title     { Faker::Lorem.sentence }
  body      { Faker::Lorem.paragraphs(3) * ' ' }
  published { true }
  section
end

Page.blueprint(:unpublished) do
  published { false }
end

Photo.blueprint do
  title       { Faker::Lorem.words(3) * ' ' }
  property    { ApartmentCommunity.make }
  photo_group { PhotoGroup.make }
end

PhotoGroup.blueprint do
  title { Faker::Lorem.words(3) * ' ' }
end

PressRelease.blueprint do
  title        { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs(2) * ' ' }
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
  name { Faker::Lorem.words(1) * ' ' }
  data { Faker::Lorem.sentence }
  project
end

ProjectUpdate.blueprint do
  body         { Faker::Lorem.paragraphs(4) * ' ' }
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
  description    { Faker::Lorem.paragraphs(1) * ' ' }
end

PropertyContactPage.blueprint do
  property
  content       { Faker::Lorem.paragraphs(2) * ' ' }
  meta_title    { Faker::Lorem.words(4) * ' ' }
  meta_keywords { Faker::Lorem.words(6) * ' ' }
end

PropertyFeaturesPage.blueprint do
  property
  text_1        { Faker::Lorem.paragraphs(2) * ' ' }
  title_1       { Faker::Lorem.words(5) * ' ' }
  text_2        { Faker::Lorem.paragraph }
  title_2       { Faker::Lorem.words(5) * ' ' }
  meta_title    { Faker::Lorem.words(4) * ' ' }
  meta_keywords { Faker::Lorem.words(6) * ' ' }
end

PropertyNeighborhoodPage.blueprint do
  property
  content       { Faker::Lorem.paragraphs(2) * ' ' }
  meta_title    { Faker::Lorem.words(4) * ' ' }
  meta_keywords { Faker::Lorem.words(6) * ' ' }
end

PropertySlideshow.blueprint do
  property
  name     { Faker::Lorem.words(1) * ' ' }
end

PropertySlide.blueprint do
  property_slideshow
  image_file_name    { Sham.file_name }
  image_content_type { 'text/jpg' }
end

PropertyToursPage.blueprint do
  property
  title         { Faker::Lorem.words(3) * ' ' }
  content       { Faker::Lorem.paragraphs(2) * ' ' }
  meta_title    { Faker::Lorem.words(4) * ' ' }
  meta_keywords { Faker::Lorem.words(6) * ' ' }
end

RecurringEmail.blueprint do
  email_address { Faker::Internet.email }
  recurring     { false }
end

RecurringEmail.blueprint(:recurring) do
  recurring { true }
end

RelatedArea.blueprint do
  area        { Area.make }
  nearby_area { Area.make }
end

RelatedNeighborhood.blueprint do
  neighborhood        { Neighborhood.make }
  nearby_neighborhood { Neighborhood.make }
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

Section.blueprint(:new_homes) do
  title { 'New Homes' }
end

Snippet.blueprint do
  name { Sham.unique_name }
  body { Faker::Lorem.paragraphs * ' ' }
end

State.blueprint do
  name { Sham.us_state }
  code { Sham.us_state_code }
end

Testimonial.blueprint do
  name  { Faker::Name.name }
  title { Faker::Lorem.sentence }
  quote { Faker::Lorem.paragraphs * ' ' }
  section
end

Tweet.blueprint do
  text      { Faker::Lorem.sentence }
  posted_at { Time.now }
  tweet_id  { ActiveSupport::SecureRandom.hex }
  twitter_account
end

TwitterAccount.blueprint do
  username { 'Bozzuto' }
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
