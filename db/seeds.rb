###
# States

[['CT', 'Connecticut'],
 ['MD', 'Maryland'],
 ['MA', 'Massachusetts'],
 ['NJ', 'New Jersey'],
 ['NY', 'New York'],
 ['PA', 'Pennsylvania'],
 ['VA', 'Virginia'],
 ['DC', 'Washington, DC']].each do |code, name|
  State.find_or_create_by_code(code, :name => name)
end

###
# Sections

# services
%w(Acquisitions Construction Development Homebuilding Land Management).each do |title|
  section = Section.find_or_create_by_title(title, :service => true)
end

# sections
['Apartments', 'New Homes', 'Services', 'News & Press', 'Pages', 'Careers'].each do |section|
  Section.find_or_create_by_title(:title => section)
end
Section.find_or_create_by_title('About Us', :about => true)

# contact topics
['General Inquiry', 'Apartments', 'New Homes', 'Acquisitions', 'Construction', 'Development', 'Homebuilding', 'Land', 'Management'].each do |topic|
  ContactTopic.find_or_create_by_topic(topic, :recipients => 'contact@bozzuto.com')
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

###
# ZIP Codes
Bozzuto::ZipCodes.load

###
# Load HyLy Property PIDs
Bozzuto::HyLy.seed_pids
