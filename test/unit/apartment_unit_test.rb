require 'test_helper'

class ApartmentUnitTest < ActiveSupport::TestCase
  context "ApartmentUnit" do
    subject { ApartmentUnit.make }

    should belong_to(:floor_plan)

    should have_many(:amenities)
    should have_many(:feed_files)

    should validate_presence_of(:floor_plan)

    should validate_numericality_of(:bedrooms)
    should validate_numericality_of(:bathrooms)
    should validate_numericality_of(:min_square_feet)
    should validate_numericality_of(:max_square_feet)
    should validate_numericality_of(:unit_rent)
    should validate_numericality_of(:market_rent)
    should validate_numericality_of(:min_rent)
    should validate_numericality_of(:max_rent)
    should validate_numericality_of(:avg_rent)

    describe "#apartment_community" do
      it "returns the associated floor plan's apartment community" do
        subject.apartment_community.should == subject.floor_plan.apartment_community
      end
    end

    describe "#square_footage" do
      before do
        subject.min_square_feet = 500
        subject.max_square_feet = 750
      end

      it "returns a string containing the minimum and maximum square footage" do
        subject.square_footage.should == '500 to 750'
      end
    end

    describe "#typus_name" do
      context "when the unit has a marketing name" do
        subject { ApartmentUnit.make(:marketing_name => 'Penthouse 1A') }

        it "returns the marketing name" do
          subject.typus_name.should == 'Penthouse 1A'
        end
      end

      context "when the unit does not have a marketing name" do
        subject { ApartmentUnit.make(:marketing_name => nil) }

        it "returns the marketing name" do
          subject.typus_name.should == "ApartmentUnit (ID: #{subject.id})"
        end
      end
    end

    describe "#bedrooms" do
      before do
        @floor_plan = ApartmentFloorPlan.make(:bedrooms => 3)
      end

      context "when the unit has a bedrooms value" do
        subject { ApartmentUnit.make(:bedrooms => 2, :floor_plan => @floor_plan) }

        it "returns the value" do
          subject.bedrooms.should == 2
        end
      end

      context "when the unit does not have a bedrooms value" do
        context "but its floor plan does" do
          subject { ApartmentUnit.make(:bedrooms => nil, :floor_plan => @floor_plan) }

          it "returns the floor plan's value" do
            subject.bedrooms.should == 3
          end
        end

        context "and neither does its floor plan" do
          subject { ApartmentUnit.make(:bedrooms => nil, :floor_plan => ApartmentFloorPlan.make(:bedrooms => nil)) }

          it "returns nil" do
            subject.bedrooms.should == nil
          end
        end
      end
    end

    describe "#bathrooms" do
      before do
        @floor_plan = ApartmentFloorPlan.make(:bathrooms => 3)
      end

      context "when the unit has a bathrooms value" do
        subject { ApartmentUnit.make(:bathrooms => 2, :floor_plan => @floor_plan) }

        it "returns the value" do
          subject.bathrooms.should == 2
        end
      end

      context "when the unit does not have a bathrooms value" do
        context "but its floor plan does" do
          subject { ApartmentUnit.make(:bathrooms => nil, :floor_plan => @floor_plan) }

          it "returns the floor plan's value" do
            subject.bathrooms.should == 3
          end
        end

        context "and neither does its floor plan" do
          subject { ApartmentUnit.make(:bathrooms => nil, :floor_plan => ApartmentFloorPlan.make(:bathrooms => nil)) }

          it "returns nil" do
            subject.bathrooms.should == nil
          end
        end
      end
    end

    describe "#name" do
      context "when there's a marketing name" do
        subject { ApartmentUnit.make(:marketing_name => 'Marketing Name', :external_cms_id => 'CMS ID') }

        it "returns the marketing name" do
          subject.name.should == 'Marketing Name'
        end
      end

      context "when there's no marketing name" do
        subject { ApartmentUnit.make(:marketing_name => nil, :external_cms_id => 'CMS ID') }

        it "returns the external CMS ID" do
          subject.name.should == 'CMS ID'
        end
      end
    end

    describe "#to_s" do
      context "when there's a marketing name" do
        subject { ApartmentUnit.make(:marketing_name => 'Marketing Name', :external_cms_id => 'CMS ID') }

        it "returns the marketing name" do
          subject.to_s.should == 'Marketing Name'
        end
      end

      context "when there's no marketing name" do
        subject { ApartmentUnit.make(:marketing_name => nil, :external_cms_id => 'CMS ID') }

        it "returns the external CMS ID" do
          subject.to_s.should == 'CMS ID'
        end
      end
    end

    describe "#rent" do
      subject { ApartmentUnit.make(:external_cms_type => 'psi', :unit_rent => 1525.0) }

      it "returns the unit rent by default" do
        subject.rent.should == '$1,525.00'
      end

      context "for a vaultware unit" do
        subject { ApartmentUnit.make(:external_cms_type => 'vaultware', :min_rent => 1322.0, :unit_rent => 1525.0) }

        it "returns the min rent" do
          subject.rent.should == '$1,322.00'
        end
      end

      context "for a property link unit" do
        subject { ApartmentUnit.make(:external_cms_type => 'property_link', :market_rent => 1497.0, :unit_rent => 1525.0) }

        it "returns the market rent" do
          subject.rent.should == '$1,497.00'
        end
      end
    end
  end
end
