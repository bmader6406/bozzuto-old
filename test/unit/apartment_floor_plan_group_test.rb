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

      describe "#short_name" do
        it "uses 'Studios' for Studio" do
          @studio.short_name.should == 'Studios'
        end

        it "uses '1 Bedrooms' for 1 Bedroom" do
          @bedroom.short_name.should == '1 Bedrooms'
        end

        it "uses '2 Bedrooms' for 2 Bedrooms" do
          @bedrooms2.short_name.should == '2 Bedrooms'
        end

        it "uses '3+ Bedrooms' for 3 or More Bedrooms" do
          @bedrooms3.short_name.should == '3+ Bedrooms'
        end

        it "uses 'Penthouses' for Penthouse" do
          @penthouse.short_name.should == 'Penthouses'
        end
      end

      describe "#cache_name" do
        it "uses 'studio' for Studio" do
          @studio.cache_name.should == 'studio'
        end

        it "uses 'one_bedroom' for 1 Bedroom" do
          @bedroom.cache_name.should == 'one_bedroom'
        end

        it "uses 'two_bedrooms' for 2 Bedrooms" do
          @bedrooms2.cache_name.should == 'two_bedrooms'
        end

        it "uses 'three_bedrooms' for 3 or More Bedrooms" do
          @bedrooms3.cache_name.should == 'three_bedrooms'
        end

        it "uses 'penthouse' for Penthouse" do
          @penthouse.cache_name.should == 'penthouse'
        end

        it "raises on anything else" do
          expect {
            @other.cache_name
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
