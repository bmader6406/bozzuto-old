require 'test_helper'

module Bozzuto
  class PropertyLinkFeedLoaderTest < ActiveSupport::TestCase
    context 'A PropertyLink Feed Loader' do
      setup do
        rm_feed_loader_tmp_files
        create_states
        @loader = PropertyLinkFeedLoader.new

        @loader.stubs(:touch_tmp_file)
        @loader.stubs(:touch_lock_file)
        @loader.stubs(:rm_lock_file)
      end


      context '#process' do
        setup do
          load_property_link_fixture_file('property_link.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'property_link.xml')
        end

        should 'create the communities' do
          assert_difference('ApartmentCommunity.count', @properties.count) do
            @loader.load
          end

          community = ApartmentCommunity.managed_by_feed(external_cms_id(@property), 'property_link').first
          attrs = community_attributes(@property)

          community_fields.each do |field|
            assert_equal attrs[field], community.send(field)
          end
        end

        context 'a community already exists with a CMS id' do
          setup do
            @external_cms_id = external_cms_id(@property)
            @community       = ApartmentCommunity.make(:property_link, :external_cms_id => @external_cms_id)
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

          assert_equal ApartmentFloorPlanGroup.one_bedroom,
            @loader.send(:floor_plan_group, @plan)
        end

        should 'return two bedrooms when bedrooms is 2' do
          @plan = mock_floor_plan(2, '')

          assert_equal ApartmentFloorPlanGroup.two_bedrooms,
            @loader.send(:floor_plan_group, @plan)
        end

        should 'return three bedrooms when bedrooms is 3 or more' do
          @plan = mock_floor_plan(3, '')

          assert_equal ApartmentFloorPlanGroup.three_bedrooms,
            @loader.send(:floor_plan_group, @plan)

          @plan = mock_floor_plan(5, '')

          assert_equal ApartmentFloorPlanGroup.three_bedrooms,
            @loader.send(:floor_plan_group, @plan)
        end
      end


      context 'processing floor plans' do
        setup do
          load_property_link_fixture_file('property_link.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'property_link.xml')

          @community = ApartmentCommunity.make(:property_link,
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

            @community.floor_plans << ApartmentFloorPlan.make_unsaved(:property_link,
              :external_cms_id     => @plan['Id'].to_i,
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
                assert_equal attrs[field],
                  @community.floor_plans[i].send(field)
              end
            end
          end

          should 'not update the floor plan group' do
            @community.reload
            assert_equal @penthouse, @community.floor_plans.first.floor_plan_group
          end
        end
      end


      context 'testing a full load' do
        setup do
          load_property_link_fixture_file('property_link.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'property_link.xml')
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
      property.at('./PropertyID/MITS:Identification/MITS:PrimaryID').content.to_i
    end

    def title(property)
      property.at('./PropertyID/MITS:Identification/MITS:MarketingName').content
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
      ident   = property.at('./PropertyID/MITS:Identification')
      address = property.at('./PropertyID/MITS:Address')
      info    = property.at('./Information')

      {
        :title             => ident.at('./MITS:MarketingName').content,
        :street_address    => address.at('./MITS:Address1').content,
        :availability_url  => info.at('./PropertyAvailabilityURL').try(:content),
        :external_cms_id   => external_cms_id(property),
        :external_cms_type => 'property_link'
      }
    end

    def floor_plan_attributes(plans)
      plans.map do |plan|
        {
          :name               => plan.at('./Name').content,
          :rolled_up          => false,
          :availability_url   => plan.at('./FloorplanAvailabilityURL').try(:content),
          :bedrooms           => (plan.at('./Room[@Type="Bedroom"]/Count').try(:content) || 0).to_i,
          :bathrooms          => plan.at('./Room[@Type="Bathroom"]/Count').content.to_f,
          :min_square_feet    => plan.at('./SquareFeet')['Min'].to_i,
          :max_square_feet    => plan.at('./SquareFeet')['Max'].to_i,
          :min_market_rent    => plan.at('./MarketRent')['Min'].to_f,
          :max_market_rent    => plan.at('./MarketRent')['Max'].to_f,
          :min_effective_rent => plan.at('./EffectiveRent')['Min'].to_f,
          :max_effective_rent => plan.at('./EffectiveRent')['Max'].to_f,
          :external_cms_id    => plan['Id'].to_i,
          :external_cms_type  => 'property_link'
        }
      end
    end

    def mock_floor_plan(bedrooms, comment = '')
      Nokogiri::XML(%{<Floorplan Id="1234"><Room Type="Bedroom"><Count>#{bedrooms}</Count></Room><Comment>#{comment}</Comment></Floorplan>}).at('./Floorplan')
    end

    def load_property_link_fixture_file(file)
      @fixture    = load_fixture_file(file)
      data        = Nokogiri::XML(@fixture)
      @properties = data.xpath('/PhysicalProperty/Property')
      @property   = @properties.first
    end
  end
end
