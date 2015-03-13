require 'test_helper'

class ApartmentUnitTest < ActiveSupport::TestCase
  context "ApartmentUnit" do
    subject { ApartmentUnit.make }

    should belong_to(:floor_plan)

    should have_many(:amenities)

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
  end
end
