module Bozzuto
  module Test
    module Extensions
      def load_fixture_file(file)
        File.read("#{Rails.root}/test/files/#{file}")
      end

      def create_states
        State.create([{ :code => 'CT', :name => 'Connecticut' },
                      { :code => 'MD', :name => 'Maryland' },
                      { :code => 'MA', :name => 'Massachusetts' },
                      { :code => 'NJ', :name => 'New Jersey' },
                      { :code => 'NY', :name => 'New York' },
                      { :code => 'PA', :name => 'Pennsylvania' },
                      { :code => 'VA', :name => 'Virginia' },
                      { :code => 'DC', :name => 'Washington, DC' }])
      end

      def create_floor_plan_groups
        ApartmentFloorPlanGroup.create(:name => 'Studio')
        ApartmentFloorPlanGroup.create(:name => '1 Bedroom')
        ApartmentFloorPlanGroup.create(:name => '2 Bedrooms')
        ApartmentFloorPlanGroup.create(:name => '3 or More Bedrooms')
        ApartmentFloorPlanGroup.create(:name => 'Penthouse')
      end
    end
  end
end
