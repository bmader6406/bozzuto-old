require 'test_helper'

class ApartmentFloorPlanTest < ActiveSupport::TestCase
  context "ApartmentFloorPlan" do
    before do
      @plan = ApartmentFloorPlan.new
    end

    should belong_to(:floor_plan_group)
    should belong_to(:apartment_community)

    should have_many(:apartment_units)

    should validate_presence_of(:name)
    should validate_presence_of(:floor_plan_group)
    should validate_presence_of(:apartment_community)

    should validate_numericality_of(:bedrooms)
    should validate_numericality_of(:bathrooms)
    should validate_numericality_of(:min_square_feet)
    should validate_numericality_of(:max_square_feet)
    should validate_numericality_of(:min_rent)
    should validate_numericality_of(:max_rent)

    describe "#to_s" do
      before do
        @plan.name = 'Wayne Manor'
      end

      it "returns the name" do
        @plan.to_s.should == 'Wayne Manor'
      end
    end

    describe "#uses_image_url?" do
      context "image_type is USE_IMAGE_URL" do
        before do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_URL
        end

        it "returns true" do
          @plan.uses_image_url?.should == true
        end
      end

      context "image_type is USE_IMAGE_FILE" do
        before do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_FILE
        end

        it "returns false" do
          @plan.uses_image_url?.should == false
        end
      end
    end

    describe "#uses_image_file?" do
      context "image_type is USE_IMAGE_URL" do
        before do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_URL
        end

        it "returns false" do
          @plan.uses_image_file?.should == false
        end
      end

      context "image_type is USE_IMAGE_FILE" do
        before do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_FILE
        end

        it "returns true" do
          @plan.uses_image_file?.should == true
        end
      end
    end

    describe "#actual_image" do
      before do
        @url  = 'http://viget.com/booya.jpg'
        @file = '/blah.jpg'

        @plan.image_url = @url
      end

      context "image_type is USE_IMAGE_URL" do
        it "returns the image url" do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_URL

          @plan.actual_image.should == @url
        end
      end

      context "image_type is USE_IMAGE_FILE" do
        it "returns the image file" do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_FILE
          @plan.image.expects(:url).returns(@file)

          @plan.actual_image.should == @file
        end
      end
    end

    context "#actual_thumb" do
      before do
        @url = 'http://viget.com/booya.jpg'
        @file = '/blah.jpg'
        @plan.image_url = @url
      end

      context "image_type is USE_IMAGE_URL" do
        it "returns the image url" do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_URL

          @plan.actual_thumb.should == @url
        end
      end

      context "image_type is USE_IMAGE_FILE" do
        it "returns the image file" do
          @plan.image_type = ApartmentFloorPlan::USE_IMAGE_FILE
          @plan.image.expects(:url).with(:thumb).returns(@file)

          @plan.actual_thumb.should == @file
        end
      end
    end

    describe "#scope_condition" do
      it "scopes by community id and floor plan group id" do
        condition = "apartment_community_id = #{@plan.apartment_community_id} AND floor_plan_group_id = #{@plan.floor_plan_group_id}"

        @plan.send(:scope_condition).should == condition
      end
    end

    describe "#available?" do
      context "available_units is > 0" do
        before do
          subject.available_units = 10
        end

        it "returns true" do
          subject.available?.should == true
        end
      end

      context "available_units is 0" do
        before do
          subject.available_units = 0
        end

        it "returns false" do
          subject.available?.should == false
        end
      end
    end

    describe "#availability" do
      before do
        subject.available_units = 10
      end

      it "returns the number of available units" do
        subject.availability.should == 10
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

    describe ".largest named scope" do
      before do
        @community = ApartmentCommunity.make

        @largest  = @community.floor_plans.make(:max_square_feet => 800)
        @smallest = @community.floor_plans.make(:max_square_feet => 400)
      end

      it "returns the largest floor plan" do
        @community.floor_plans.largest.first.should == @largest
      end
    end

    describe ".non_zero_min_rent named scope" do
      before do
        @community = ApartmentCommunity.make

        @no_rent   = @community.floor_plans.make(:min_rent => nil)
        @zero_rent = @community.floor_plans.make(:min_rent => 0)
        @has_rent  = @community.floor_plans.make(:min_rent => 2000)
      end

      it "returns only the plans that have non-zero min rent" do
        @community.floor_plans.non_zero_min_rent.should == [@has_rent]
      end
    end

    Bozzuto::ExternalFeed::Feed.feed_types.each do |type|
      describe "#managed_by_#{type}?" do
        context "floor plan is managed by #{type.titlecase}" do
          before { @plan = ApartmentFloorPlan.make(type.to_sym) }

          it "returns true" do
            @plan.send("managed_by_#{type}?").should == true
          end
        end

        context "floor plan is not managed by #{type.titlecase}" do
          before { @plan = ApartmentFloorPlan.make }

          it "returns false" do
            @plan.send("managed_by_#{type}?").should == false
          end
        end
      end
    end

    describe "#disconnect_from_external_cms!" do
      subject { ApartmentFloorPlan.make(:vaultware) }

      it "resets the external CMS identifiers to nil" do
        subject.disconnect_from_external_cms!

        subject.reload

        subject.external_cms_id.should == nil
        subject.external_cms_type.should == nil
      end
    end
  end

  context "The ApartmentFloorPlan class" do
    describe "managed_by_* named scopes" do
      before do
        @vaultware     = ApartmentFloorPlan.make(:vaultware)
        @property_link = ApartmentFloorPlan.make(:property_link)
        @other         = ApartmentFloorPlan.make
      end

      context "vaultware" do
        it "returns only the Vaultware communities" do
          ApartmentFloorPlan.managed_by_vaultware.all.should == [@vaultware]
        end
      end

      context "property_link" do
        it "returns only the PropertyLink communities" do
          ApartmentFloorPlan.managed_by_property_link.all.should == [@property_link]
        end
      end
    end
  end
end
