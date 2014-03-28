require 'test_helper'

module Bozzuto
  class RentCafeFeedLoaderTest < ActiveSupport::TestCase
    context "A RentCafe Feed Loader" do
      before do
        rm_feed_loader_tmp_files

        create_states
        create_floor_plan_groups

        @loader = RentCafeFeedLoader.new

        @loader.stubs(:touch_tmp_file)
        @loader.stubs(:touch_lock_file)
        @loader.stubs(:rm_lock_file)
      end


      describe "#process" do
        before do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')
        end

        it "creates the communities" do
          expect {
            @loader.load
          }.to change { ApartmentCommunity.count }.by(@properties.count)

          community = ApartmentCommunity.managed_by_feed(external_cms_id(@property), 'rent_cafe').first
          attrs = community_attributes(@property)

          community_fields.each do |field|
            community.send(field).should == attrs[field]
          end
        end

        context "a community already exists with a CMS id" do
          before do
            @external_cms_id = external_cms_id(@property)
            @community       = ApartmentCommunity.make(:rent_cafe, :external_cms_id => @external_cms_id)
          end

          it "updates the existing community" do
            expect {
              @loader.load
            }.to change { ApartmentCommunity.count }.by(@properties.count - 1)

            @community.reload

            @community.title.should == title(@property)
          end
        end
      end


      describe "#floor_plan_group" do
        it "returns studio when bedrooms is 0" do
          @plan = mock_floor_plan(0, '')

          @loader.send(:floor_plan_group, @plan).should == ApartmentFloorPlanGroup.studio
        end

        it "returns one bedroom when bedrooms is 1" do
          @plan = mock_floor_plan(1, '')

          @loader.send(:floor_plan_group, @plan).should == ApartmentFloorPlanGroup.one_bedroom
        end

        it "returns two bedrooms when bedrooms is 2" do
          @plan = mock_floor_plan(2, '')

          @loader.send(:floor_plan_group, @plan).should == ApartmentFloorPlanGroup.two_bedrooms
        end

        it "returns three bedrooms when bedrooms is 3 or more" do
          @plan = mock_floor_plan(3, '')

          @loader.send(:floor_plan_group, @plan).should == ApartmentFloorPlanGroup.three_bedrooms

          @plan = mock_floor_plan(5, '')

          @loader.send(:floor_plan_group, @plan).should == ApartmentFloorPlanGroup.three_bedrooms
        end
      end


      describe "processing floor plans" do
        before do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')

          @community = ApartmentCommunity.make(:rent_cafe,
            :external_cms_id => external_cms_id(@property)
          )

          @plans       = @property.xpath('./Floorplan')
          @plans_attrs = floor_plan_attributes(@property, @plans)
        end

        context "when no matching floor plans exist" do
          it "creates the floor plans" do
            expect {
              @loader.load
            }.to change { @community.floor_plans.count }.by(@plans.count)

            @community.floor_plans.count.should == @plans.count

            @plans_attrs.zip(@community.floor_plans).each do |attrs, plan|
              attrs.each do |attr, val|
                plan.send(attr).should == val
              end
            end
          end
        end


        context "when syncing with a floor plan that already exists" do
          before do
            @penthouse = ApartmentFloorPlanGroup.penthouse

            @plan = @plans.first

            @community.floor_plans << ApartmentFloorPlan.make_unsaved(:rent_cafe,
              :external_cms_id     => @plan['id'].to_i,
              :apartment_community => @community,
              :image_url           => nil,
              :floor_plan_group    => @penthouse
            )

            expect {
              @loader.load
            }.to change { @community.floor_plans.count }.by(@plans.count - 1)
          end

          it "updates the existing floor plan" do
            @community.floor_plans.count.should == @plans.count

            @plans_attrs.zip(@community.floor_plans).each do |attrs, plan|
              attrs.each do |attr, val|
                plan.send(attr).should == val
              end
            end
          end

          it "doesn't update the floor plan group" do
            @community.reload
            @community.floor_plans.first.floor_plan_group.should == @penthouse
          end
        end
      end


      describe "processing hours" do
        before do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')

          @hours = @property.xpath('./Information/OfficeHour')

          @community = ApartmentCommunity.make(:rent_cafe,
            :external_cms_id => external_cms_id(@property)
          )

          @hour_attrs = attributes_for_office_hours(@hours)
        end

        it "loads all office hours" do
          @loader.load

          @community.reload.office_hours.should == @hour_attrs
        end
      end

      describe "testing a full load" do
        before do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')
        end

        it "loads all the properties and floor plans" do
          @loader.load

          @properties.each do |property|
            attrs = community_attributes(property)
            community = ApartmentCommunity.managed_by_feed(attrs[:external_cms_id], attrs[:external_cms_type]).first

            community_fields.each do |field|
              community.send(field).should == attrs[field]
            end

            plans      = property.xpath('./Floorplan')
            plan_attrs = floor_plan_attributes(property, plans)

            plan_attrs.zip(community.floor_plans).each do |attrs, plan|
              attrs.each do |field, value|
                plan.send(field).should == value
              end
            end
          end
        end
      end
    end


    def external_cms_id(property)
      property.at('./Identification/PrimaryID').content
    end

    def title(property)
      property.at('./Identification/MarketingName').content
    end

    def community_fields
      [
        :title,
        :street_address,
        :availability_url,
        :external_cms_id,
        :external_cms_type
      ]
    end

    def community_attributes(property)
      ident   = property.at('./Identification')
      address = property.at('./Identification/Address')
      info    = property.at('./Information')

      {
        :title             => ident.at('./MarketingName').content,
        :street_address    => address.at('./Address1').content,
        :availability_url  => property.at('./Availability').try(:content),
        :external_cms_id   => external_cms_id(property),
        :external_cms_type => 'rent_cafe'
      }
    end

    def floor_plan_attributes(property, plans)
      plans.map do |plan|
        file = property.xpath("./File[@id=#{plan['id']}]").first

        {
          :name               => plan.at('./Name').content,
          :rolled_up          => false,
          :availability_url   => plan.at('./Amenities/General').try(:content),
          :available_units    => plan.at('./UnitsAvailable').content.to_i,
          :bedrooms           => (plan.at('./Room[@type="bedroom"]/Count').try(:content) || 0).to_i,
          :bathrooms          => plan.at('./Room[@type="bathroom"]/Count').content.to_f,
          :min_square_feet    => plan.at('./SquareFeet')['min'].to_i,
          :max_square_feet    => plan.at('./SquareFeet')['max'].to_i,
          :min_market_rent    => plan.at('./MarketRent')['min'].to_f,
          :max_market_rent    => plan.at('./MarketRent')['max'].to_f,
          :min_effective_rent => plan.at('./EffectiveRent')['min'].to_f,
          :max_effective_rent => plan.at('./EffectiveRent')['max'].to_f,
          :image_url          => (file.at('./Src').content rescue nil),
          :external_cms_id    => plan['id'],
          :external_cms_type  => 'rent_cafe'
        }
      end
    end

    def attributes_for_office_hours(hours)
      hours.collect do |hour|
        office_hour_attributes(hour)
      end
    end

    def office_hour_attributes(hour)
      {
        :open_time  => hour.at('./OpenTime').content,
        :close_time => hour.at('./CloseTime').content,
        :day        => hour.at('./Day').content
      }
    end

    def mock_floor_plan(bedrooms, comment = '')
      Nokogiri::XML(%{<Floorplan Id="1234"><Room type="bedroom"><Count>#{bedrooms}</Count></Room><Comment>#{comment}</Comment></Floorplan>}).at('./Floorplan')
    end

    def load_rent_cafe_fixture_file(file)
      @fixture = load_fixture_file(file)
      data     = Nokogiri::XML(@fixture)

      data.remove_namespaces!

      @properties = data.xpath('/PhysicalProperty/Property')
      @property   = @properties.first
    end
  end
end
