require 'test_helper'

module Bozzuto
  class RentCafeFeedLoaderTest < ActiveSupport::TestCase
    context 'A RentCafe Feed Loader' do
      setup do
        rm_feed_loader_tmp_files

        create_states
        create_floor_plan_groups

        @loader = RentCafeFeedLoader.new

        @loader.stubs(:touch_tmp_file)
        @loader.stubs(:touch_lock_file)
        @loader.stubs(:rm_lock_file)
      end


      context '#process' do
        setup do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')
        end

        should 'create the communities' do
          assert_difference('ApartmentCommunity.count', @properties.count) do
            @loader.load
          end

          community = ApartmentCommunity.managed_by_feed(external_cms_id(@property), 'rent_cafe').first
          attrs = community_attributes(@property)

          community_fields.each do |field|
            assert_equal attrs[field], community.send(field)
          end
        end

        context 'a community already exists with a CMS id' do
          setup do
            @external_cms_id = external_cms_id(@property)
            @community       = ApartmentCommunity.make(:rent_cafe, :external_cms_id => @external_cms_id)
          end

          should 'update the existing community' do
            assert_difference('ApartmentCommunity.count', @properties.count - 1) do
              @loader.load
            end

            @community.reload

            assert_equal title(@property), @community.title
          end
        end
      end


      context '#floor_plan_group' do
        should 'return studio when bedrooms is 0' do
          @plan = mock_floor_plan(0, '')

          assert_equal ApartmentFloorPlanGroup.studio,
            @loader.send(:floor_plan_group, @plan)
        end

        should 'return one bedroom when bedrooms is 1' do
          @plan = mock_floor_plan(1, '')

          assert_equal ApartmentFloorPlanGroup.one_bedroom, @loader.send(:floor_plan_group, @plan)
        end

        should 'return two bedrooms when bedrooms is 2' do
          @plan = mock_floor_plan(2, '')

          assert_equal ApartmentFloorPlanGroup.two_bedrooms, @loader.send(:floor_plan_group, @plan)
        end

        should 'return three bedrooms when bedrooms is 3 or more' do
          @plan = mock_floor_plan(3, '')

          assert_equal ApartmentFloorPlanGroup.three_bedrooms, @loader.send(:floor_plan_group, @plan)

          @plan = mock_floor_plan(5, '')

          assert_equal ApartmentFloorPlanGroup.three_bedrooms, @loader.send(:floor_plan_group, @plan)
        end
      end


      context 'processing floor plans' do
        setup do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')

          @community = ApartmentCommunity.make(:rent_cafe,
            :external_cms_id => external_cms_id(@property)
          )

          @plans       = @property.xpath('./Floorplan')
          @plans_attrs = floor_plan_attributes(@plans)
        end

        context "when no matching floor plans exist" do
          should 'create the floor plans' do
            assert_difference('@community.floor_plans.count', @plans.count) do
              @loader.load
            end

            assert_equal @plans.count, @community.floor_plans.count

            @plans_attrs.each_with_index do |attrs, i|
              attrs.each_key do |field|
                assert_equal attrs[field], @community.floor_plans[i].send(field)
              end
            end
          end
        end


        context 'when syncing with a floor plan that already exists' do
          setup do
            @penthouse = ApartmentFloorPlanGroup.penthouse

            @plan = @plans.first

            @community.floor_plans << ApartmentFloorPlan.make_unsaved(:rent_cafe,
              :external_cms_id     => @plan['id'].to_i,
              :apartment_community => @community,
              :image_url           => nil,
              :floor_plan_group    => @penthouse
            )

            assert_difference('@community.floor_plans.count', @plans.count - 1) do
              @loader.load
            end
          end

          should 'update the existing floor plan' do
            assert_equal @plans.count, @community.floor_plans.count

            @plans_attrs.each_with_index do |attrs, i|
              attrs.each_key do |field|
                assert_equal attrs[field], @community.floor_plans[i].send(field)
              end
            end
          end

          should 'not update the floor plan group' do
            @community.reload
            assert_equal @penthouse, @community.floor_plans.first.floor_plan_group
          end
        end
      end


      context "processing hours" do
        setup do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')

          @hours = @property.xpath('./Information/OfficeHour')

          @community = ApartmentCommunity.make(:rent_cafe,
            :external_cms_id => external_cms_id(@property)
          )

          @hour_attrs = attributes_for_office_hours(@hours)
        end

        should "load all office hours" do
          @loader.load

          assert_equal @hour_attrs, @community.reload.office_hours
        end
      end

      context 'testing a full load' do
        setup do
          load_rent_cafe_fixture_file('rent_cafe.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'rent_cafe.xml')
        end

        should 'load all the properties and floor plans' do
          @loader.load

          @properties.each do |property|
            attrs = community_attributes(property)
            community = ApartmentCommunity.managed_by_feed(attrs[:external_cms_id], attrs[:external_cms_type]).first

            community_fields.each do |field|
              assert_equal attrs[field], community.send(field)
            end

            plans      = property.xpath('./Floorplan')
            plan_attrs = floor_plan_attributes(plans)

            plan_attrs.each_with_index do |attrs, i|
              attrs.each_key do |field|
                assert_equal attrs[field], community.floor_plans[i].send(field)
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
        :availability_url  => info.at('./Availability').try(:content),
        :external_cms_id   => external_cms_id(property),
        :external_cms_type => 'rent_cafe'
      }
    end

    def floor_plan_attributes(plans)
      plans.map do |plan|
        file = @property.xpath("./File[@id=#{plan['id']}]").first

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

      #binding.pry
    end
  end
end
