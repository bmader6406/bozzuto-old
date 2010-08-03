###
# States
State.create([{ :code => 'CT', :name => 'Connecticut' },
              { :code => 'MD', :name => 'Maryland' },
              { :code => 'MA', :name => 'Massachusetts' },
              { :code => 'NJ', :name => 'New Jersey' },
              { :code => 'NY', :name => 'New York' },
              { :code => 'PA', :name => 'Pennsylvania' },
              { :code => 'VA', :name => 'Virginia' },
              { :code => 'DC', :name => 'Washington, DC' }])

###
# Sections

# services
%w(Acquisitions Construction Development Homebuilding Land Management).each do |title|
  section = Section.create(:title => title, :service => true)
end

# sections
['Apartments', 'New Homes', 'Services', 'News & Press', 'Pages'].each do |section|
  Section.create(:title => section)
end
Section.create(:title => 'About Us', :about => true)

# contact topics
['General Inquiry', 'Apartments', 'New Homes', 'Acquisitions', 'Construction', 'Development', 'Homebuilding', 'Land', 'Management'].each do |topic|
  ContactTopic.create(:topic => topic, :recipients => 'contact@bozzuto.com')
end


###
# Apartment Floor Plan Groups
['Studio', '1 Bedroom', '2 Bedrooms', '3 or More Bedrooms', 'Penthouse'].each do |group|
  ApartmentFloorPlanGroup.find_or_create_by_name(group)
end

[{ :title => 'Neighborhood', :flickr_raw_title => 'neighborhood' },
 { :title => 'Community Amenities', :flickr_raw_title => 'community-amenities' },
 { :title => 'Views', :flickr_raw_title => 'views' },
 { :title => 'Features', :flickr_raw_title => 'apartment-features' }].each do |attrs|
  PhotoGroup.find_or_create_by_title(attrs)
end


###
# Create a default home page
if HomePage.count.zero?
  HomePage.new.save(false)
end
