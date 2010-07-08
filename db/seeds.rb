# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

State.create([{ :code => 'CT', :name => 'Connecticut' },
              { :code => 'MD', :name => 'Maryland' },
              { :code => 'MA', :name => 'Massachusetts' },
              { :code => 'NJ', :name => 'New Jersey' },
              { :code => 'NY', :name => 'New York' },
              { :code => 'PA', :name => 'Pennsylvania' },
              { :code => 'VA', :name => 'Virginia' },
              { :code => 'DC', :name => 'Washington, DC' }])

%w(Acquisitions Construction Development Homebuilding Land Management).each do |title|
  section = Section.create(:title => title, :service => true)
end
Section.create(:title => 'About')
Section.create(:title => 'Apartments')
Section.create(:title => 'New Homes')

['Studio', '1 Bedroom', '2 Bedrooms', '3 or More Bedrooms', 'Penthouse'].each do |group|
  ApartmentFloorPlanGroup.find_or_create_by_name(group)
end

parser = Vaultware::Parser.new
parser.parse(RAILS_ROOT + '/db/seeds/vaultware.xml')
parser.process

['Studio', '1 Bedroom', '2 Bedrooms', '3 or More Bedrooms', 'Penthouse'].each do |name|
  ApartmentFloorPlanGroup.find_or_create_by_name(name)
end
