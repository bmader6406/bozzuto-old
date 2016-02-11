###
# States

[['CT', 'Connecticut'],
 ['MD', 'Maryland'],
 ['MA', 'Massachusetts'],
 ['NJ', 'New Jersey'],
 ['NY', 'New York'],
 ['PA', 'Pennsylvania'],
 ['VA', 'Virginia'],
 ['DC', 'Washington, DC']
].each do |code, name|
  State.find_or_create_by(code: code) do |state|
    state.name = name
  end
end

###
# Sections

# services
[
 'Acquisitions',
 'Construction',
 'Deveopment',
 'Homebuilding',
 'Land',
 'Management'
].each do |title|
  ection = Section.find_or_create_by(title: title) do |section|
    section.service = true
  end
end

# sections
[
  'Apartments',
  'New Homes',
  'Services',
  'News & Press',
  'Pages',
  'Careers'
].each do |section|
  Section.find_or_create_by(title: section)
end

Section.find_or_create_by(title: 'About Us') do |section|
  section.about = true
end

###
# Contact topics
[
  'General Inquiry',
  'Apartments',
  'New Homes',
  'Acquisitions',
  'Construction',
  'Development',
  'Homebuilding',
  'Land',
  'Management'
].each do |topic|
  ContactTopic.find_or_create_by(topic: topic) do |contact_topic|
    contact_topic.recipients = 'contact@bozzuto.com'
  end
end


###
# Apartment Floor Plan Groups
[
  'Studio',
  '1 Bedroom',
  '2 Bedrooms',
  '3 or More Bedrooms',
  'Penthouse'
].each do |name|
  ApartmentFloorPlanGroup.find_or_create_by(name: name)
end

[
  'Neighborhood',
  'Community Amenities',
  'Views',
  'Features'
].each do |title|
  PhotoGroup.find_or_create_by(title: title)
end


###
# Create a default home page
if HomePage.count.zero?
  HomePage.create(body: "hay")
end

###
# ZIP Codes
Bozzuto::ZipCodes.load

###
# Load HyLy Property PIDs
Bozzuto::HyLy.seed_pids
