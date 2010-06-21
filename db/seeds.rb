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

City.create([{ :name => 'Arlington', :state => State.find_by_code('VA') },
             { :name => 'Alexandria', :state => State.find_by_code('VA') },
             { :name => 'Annapolis', :state => State.find_by_code('MD') },
             { :name => 'Boston', :state => State.find_by_code('MA') },
             { :name => 'Trenton', :state => State.find_by_code('NJ') },
             { :name => 'New York', :state => State.find_by_code('NY') },
             { :name => 'Pittsburgh', :state => State.find_by_code('PA') },
             { :name => 'Washington', :state => State.find_by_code('DC') },
             { :name => 'Hartford', :state => State.find_by_code('CT') }])


%w(Acquisitions Construction Development Homes Land Management).each do |title|
  section = Section.create(:title => title)
  Service.create(:title => title, :section => section, :service => true)
end
Section.create(:title => 'About')
Section.create(:title => 'Apartments')
Section.create(:title => 'New Homes')
