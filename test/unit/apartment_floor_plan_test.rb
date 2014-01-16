require 'test_helper'

class ApartmentFloorPlanTest < ActiveSupport::TestCase
  context "ApartmentFloorPlan" do
    before do
      @plan = ApartmentFloorPlan.new
    end

    should_belong_to :floor_plan_group, :apartment_community

    should_validate_presence_of :name,
      :floor_plan_group,
      :apartment_community

    should_validate_numericality_of :bedrooms,
      :bathrooms,
      :min_square_feet,
      :max_square_feet,
      :min_market_rent,
      :max_market_rent,
      :min_effective_rent,
      :max_effective_rent

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

    describe "before validating" do
      before do
        @community = ApartmentCommunity.make

        @plan = ApartmentFloorPlan.make(
          :min_market_rent     => 100,
          :max_market_rent     => 200,
          :min_effective_rent  => 300,
          :max_effective_rent  => 400,
          :apartment_community => @community,
          :floor_plan_group    => ApartmentFloorPlanGroup.studio
        )

        @community.reload
      end

      context "community is not using market prices" do
        before do
          @community.use_market_prices = false
          @community.save

          @plan.reload
          @plan.save
        end

        it "caches effective rents" do
          @plan.min_rent.should == @plan.min_effective_rent
          @plan.max_rent.should == @plan.max_effective_rent
        end
      end

      context "community is using market prices" do
        before do
          @community.use_market_prices = true
          @community.save

          @plan.reload
          @plan.save
        end

        it "caches market rents" do
          @plan.min_rent.should == @plan.min_market_rent
          @plan.max_rent.should == @plan.max_market_rent
        end
      end
    end

    describe "#cheapest and #largest named scopes" do
      before do
        @community = ApartmentCommunity.make

        @largest = @community.floor_plans.make(
          :min_market_rent    => 2000,
          :min_effective_rent => 2000,
          :max_square_feet    => 800
        )

        @cheapest_market = @community.floor_plans.make(
          :min_market_rent    => 800,
          :min_effective_rent => 1000,
          :max_square_feet    => 400
        )

        @cheapest_effective = @community.floor_plans.make(
          :min_market_rent    => 1000,
          :min_effective_rent => 800,
          :max_square_feet    => 400
        )
      end

      it "returns the largest floor plan" do
        @community.floor_plans.largest.first.should == @largest
      end
    end

    context "#non_zero_min_rent named scope" do
      before do
        @community = ApartmentCommunity.make

        @no_rent = @community.floor_plans.make(
          :min_market_rent    => nil,
          :min_effective_rent => nil
        )

        @zero_rent = @community.floor_plans.make(
          :min_market_rent    => 0,
          :min_effective_rent => 0
        )

        @has_rent = @community.floor_plans.make(
          :min_market_rent    => 2000,
          :min_effective_rent => 2000
        )
      end

      it "returns only the plans that have non-zero min rent" do
        @community.floor_plans.non_zero_min_rent.should == [@has_rent]
      end
    end

    Bozzuto::ExternalFeedLoader.feed_types.each do |type|
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
        subject.external_cms_file_id.should == nil
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
