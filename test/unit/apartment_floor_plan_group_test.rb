require 'test_helper'

class ApartmentFloorPlanGroupTest < ActiveSupport::TestCase
  context "ApartmentFloorPlanGroup" do
    before do
      create_floor_plan_groups
    end

    should_have_many :floor_plans

    should_validate_presence_of :name

    describe "named scopes" do
      context ":except" do
        before do
          @all    = ApartmentFloorPlanGroup.all
          @studio = ApartmentFloorPlanGroup.studio
        end

        it "returns all except the parameter" do
          ApartmentFloorPlanGroup.except(@studio).should == @all - [@studio]
        end
      end
    end

    context "custom names" do
      before do
        @studio    = ApartmentFloorPlanGroup.studio
        @bedroom   = ApartmentFloorPlanGroup.one_bedroom
        @bedrooms2 = ApartmentFloorPlanGroup.two_bedrooms
        @bedrooms3 = ApartmentFloorPlanGroup.three_bedrooms
        @penthouse = ApartmentFloorPlanGroup.penthouse
        @other     = ApartmentFloorPlanGroup.make(:name => 'Hooray')
      end

      describe "#list_name" do
        it "uses 'Studios' for Studio" do
          @studio.list_name.should == 'Studios'
        end

        it "uses '1BR' for 1 Bedroom" do
          @bedroom.list_name.should == '1BR'
        end

        it "uses '2BR' for 2 Bedrooms" do
          @bedrooms2.list_name.should == '2BR'
        end

        it "uses '3BR' for 3 or More Bedrooms" do
          @bedrooms3.list_name.should == '3BR'
        end

        it "uses 'Penthouses' for Penthouse" do
          @penthouse.list_name.should == 'Penthouses'
        end
      end

      describe "#name_for_cache" do
        it "uses 'studio' for Studio" do
          @studio.name_for_cache.should == 'studio'
        end

        it "uses '1_bedroom' for 1 Bedroom" do
          @bedroom.name_for_cache.should == '1_bedroom'
        end

        it "uses '2_bedroom' for 2 Bedrooms" do
          @bedrooms2.name_for_cache.should == '2_bedroom'
        end

        it "uses '3_bedroom' for 3 or More Bedrooms" do
          @bedrooms3.name_for_cache.should == '3_bedroom'
        end

        it "uses 'penthouse' for Penthouse" do
          @penthouse.name_for_cache.should == 'penthouse'
        end

        it "raises on anything else" do
          expect {
            @other.name_for_cache
          }.to raise_error(RuntimeError)
        end
      end

      describe "#plural_name" do
        it "uses 'Studios' for Studio" do
          @studio.plural_name.should == 'Studios'
        end

        it "uses '1 Bedrooms' for 1 Bedroom" do
          @bedroom.plural_name.should == '1 Bedrooms'
        end

        it "uses '2 Bedrooms' for 2 Bedrooms" do
          @bedrooms2.plural_name.should == '2 Bedrooms'
        end

        it "uses '3 Bedrooms' for 3 or More Bedrooms" do
          @bedrooms3.plural_name.should == '3 or More Bedrooms'
        end

        it "uses 'Penthouses' for Penthouse" do
          @penthouse.plural_name.should == 'Penthouses'
        end
      end
    end
  end
end
