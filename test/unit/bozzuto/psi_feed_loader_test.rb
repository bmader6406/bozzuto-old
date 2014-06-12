require 'test_helper'

module Bozzuto
  class PsiFeedLoaderTest < ActiveSupport::TestCase
    context "A PSI Feed Loader" do
      before do
        rm_feed_loader_tmp_files

        create_states
        create_floor_plan_groups

        @loader = PsiFeedLoader.new

        @loader.stubs(:touch_tmp_file)
        @loader.stubs(:touch_lock_file)
        @loader.stubs(:rm_lock_file)
      end

      describe "#process" do
        before do
          load_psi_fixture_file('psi.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'psi.xml')
        end

        it "creates the communities" do
          expect {
            @loader.load
          }.to change { ApartmentCommunity.count }.from(0).to(@properties.count)

          community = ApartmentCommunity.find_by_external_cms_id(external_cms_id(@property))
          attrs = community_attributes(@property)

          community_fields.each do |field|
            community.send(field).should == attrs[field]
          end
        end

        context "community already exists with a PSI id" do
          before do
            @external_cms_id = external_cms_id(@property)
            @community       = ApartmentCommunity.make(:psi, :external_cms_id => @external_cms_id)
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

      describe "#rolled_up?" do
        context "any Floorplan node contains more than 1 File node" do
          before do
            load_psi_fixture_file('psi_rolled_up.xml')
          end

          it "returns true" do
            @loader.send(:rolled_up?, @property).should == true
          end
        end

        context "any Floorplan node contains 0 or 1 file nodes" do
          before do
            load_psi_fixture_file('psi_unrolled.xml')
          end

          it "returns false" do
            @loader.send(:rolled_up?, @property).should == false
          end
        end
      end

      describe "#floor_plan_group" do
        it "returns penthouse when comment is penthouse" do
          @plan = mock_floor_plan(2, 'Penthouse')

          @loader.send(:floor_plan_group, @plan).should == ApartmentFloorPlanGroup.penthouse
        end

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
        context "for a rolled up property" do
          before do
            load_psi_fixture_file('psi_rolled_up.xml')
            @loader.file = File.join(Rails.root, 'test', 'files', 'psi.xml')

            @plans = @property.xpath('./Floorplan')

            @community = ApartmentCommunity.make(:psi,
              :external_cms_id => external_cms_id(@property)
            )

            @plans_attrs = attributes_for_rolled_up_floor_plans(@plans)
          end

          context "no matching floor plans exist" do
            it "creates the floor plans" do
              expect {
                @loader.load
              }.to change { @community.floor_plans.count }.by(@plans.count)

              @community.floor_plans.count.should == @plans.count

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  @community.floor_plans[i].send(field).should == attrs[field]
                end
              end
            end
          end

          context "syncing with a floor plan that already exists" do
            before do
              @plan = @plans.first
              file  = @plan.xpath('./File').first

              @community.floor_plans << ApartmentFloorPlan.make_unsaved(:psi,
                :external_cms_id      => @plan.at('./Identification/IDValue').content,
                :external_cms_file_id => (file['FileID'] rescue nil),
                :apartment_community  => @community,
                :image_url            => nil
              )
              @plans_attrs = attributes_for_rolled_up_floor_plans(@plans)
            end

            it "updates the floor plans" do
              expect {
                @loader.load
              }.to change { @community.floor_plans.count }.by(@plans.count - 1)

              @community.floor_plans.count.should == @plans.count

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  @community.floor_plans[i].send(field).should == attrs[field]
                end
              end
            end
          end
        end


        context "for an unrolled property" do
          before do
            load_psi_fixture_file('psi_unrolled.xml')
            @loader.file = File.join(Rails.root, 'test', 'files', 'psi_unrolled.xml')

            @community = ApartmentCommunity.make(:psi,
              :external_cms_id => external_cms_id(@property)
            )

            @plans = @property.xpath('./Floorplan')
            @plans_attrs = attributes_for_unrolled_floor_plans(@plans)
          end

          context "no matching floor plans exist" do
            it "creates the floor plans" do
              expect {
                @loader.load
              }.to change { @community.floor_plans.count }.by(@plans.count)

              @community.floor_plans.count.should == @plans.count

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  @community.floor_plans[i].send(field).should == attrs[field]
                end
              end
            end
          end

          context "syncing with a floor plan that already exists" do
            before do
              @penthouse = ApartmentFloorPlanGroup.penthouse

              @plan = @plans.first

              @community.floor_plans << ApartmentFloorPlan.make_unsaved(:psi,
                :external_cms_id     => @plan.xpath('./Identification/IDValue').first.content,
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

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  @community.floor_plans[i].send(field).should == attrs[field]
                end
              end
            end

            it "doesn't update the floor plan group" do
              @community.reload
              @community.floor_plans.first.floor_plan_group.should == @penthouse
            end
          end
        end
      end

      describe "processing hours" do
        before do
          load_psi_fixture_file('psi.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'psi.xml')

          @hours = @property.xpath('./Information/OfficeHour')

          @community = ApartmentCommunity.make(:psi,
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
          load_psi_fixture_file('psi.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'psi.xml')
        end

        it "loads all the properties and floor plans" do
          @loader.load

          @properties.each do |property|
            attrs = community_attributes(property)
            community = ApartmentCommunity.find_by_external_cms_id(attrs[:external_cms_id])

            community_fields.each do |field|
              community.send(field).should == attrs[field]
            end

            plans = property.xpath('./Floorplan')
            attrs = if @loader.send(:rolled_up?, property)
              attributes_for_rolled_up_floor_plans(plans)
            else
              attributes_for_unrolled_floor_plans(plans)
            end

            attrs.each_with_index do |attrs, i|
              attrs.each_key do |field|
                community.floor_plans[i].send(field).should == attrs[field]
              end
            end
          end
        end
      end
    end


    def external_cms_id(property)
      property.at('./PropertyID/Identification/IDValue').content
    end

    def title(property)
      property.at('./PropertyID/MarketingName').content
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
      address          = property.at('./PropertyID/Address/Address').content
      availability_url = property.at('./Information/PropertyAvailabilityURL').try(:content)

      {
        :title             => title(property),
        :street_address    => address,
        :availability_url  => availability_url,
        :external_cms_id   => external_cms_id(property),
        :external_cms_type => 'psi'
      }
    end

    def attributes_for_unrolled_floor_plans(plans)
      plans.inject([]) do |array, plan|
        array << unrolled_floor_plan_attributes(plan)
      end
    end

    def attributes_for_rolled_up_floor_plans(plans)
      plans.inject([]) do |array, plan|
        array << rolled_up_floor_plan_attributes(plan)
      end
    end

    def attributes_for_office_hours(hours)
      hours.collect do |hour|
        office_hour_attributes(hour)
      end
    end

    def unrolled_floor_plan_attributes(plan)
      attrs = floor_plan_attributes(plan)
      file = plan.at('./File')

      attrs[:external_cms_file_id] = (file['FileID'] rescue nil)
      attrs[:image_url]            = (file.at('./Src').content rescue nil)

      attrs
    end

    def rolled_up_floor_plan_attributes(plan)
      attrs = floor_plan_attributes(plan)
      file = plan.at('./File')

      attrs[:external_cms_file_id] = (file['FileID'] rescue nil)
      attrs[:image_url]            = (file.at('./Src').content rescue nil)
      attrs[:rolled_up]            = true

      attrs
    end

    def floor_plan_attributes(plan)
      {
        :name               => plan.at('./Name').content,
        :rolled_up          => false,
        :availability_url   => plan.at('./FloorplanAvailabilityURL').content,
        :available_units    => plan.at('./DisplayedUnitsAvailable').content.to_i,
        :bedrooms           => plan.at('./Room[@RoomType="Bedroom"]/Count').content.to_i,
        :bathrooms          => plan.at('./Room[@RoomType="Bathroom"]/Count').content.to_f,
        :min_square_feet    => plan.at('./SquareFeet')['Min'].to_i,
        :max_square_feet    => plan.at('./SquareFeet')['Max'].to_i,
        :min_rent           => plan.at('./MarketRent')['Min'].to_f,
        :max_rent           => plan.at('./MarketRent')['Max'].to_f,
        :external_cms_id    => plan.at('./Identification/IDValue').content,
        :external_cms_type  => 'psi'
      }
    end

    def office_hour_attributes(hour)
      {
        :open_time  => hour.at('./OpenTime').content,
        :close_time => hour.at('./CloseTime').content,
        :day        => hour.at('./Day').content
      }
    end

    def mock_floor_plan(bedrooms, comment = '')
      Nokogiri::XML(%{<Floorplan><Identification><IDValue>1234</IDValue></Identification><Comment>#{comment}</Comment><Room RoomType="Bedroom"><Count>#{bedrooms}</Count></Room></Floorplan>}).at('./Floorplan')
    end

    def load_psi_fixture_file(file)
      @fixture = load_fixture_file(file)
      data     = Nokogiri::XML(@fixture)

      data.remove_namespaces!

      @properties = data.xpath('/PhysicalProperty/Property')
      @property   = @properties.find { |property| property.xpath('./Floorplan').any? } # Some properties didn't have floor plans
    end
  end
end
