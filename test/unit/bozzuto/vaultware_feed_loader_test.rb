require 'test_helper'

module Bozzuto
  class VaultwareFeedLoaderTest < ActiveSupport::TestCase
    context 'A Vaultware Feed Loader' do
      setup do
        rm_feed_loader_tmp_files
        create_states
        @loader = VaultwareFeedLoader.new

        @loader.stubs(:touch_tmp_file)
        @loader.stubs(:touch_lock_file)
        @loader.stubs(:rm_lock_file)
      end

      context '#process' do
        setup do
          load_vaultware_fixture_file('unrolled.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'unrolled.xml')
        end

        should 'create the communities' do
          assert_difference('ApartmentCommunity.count', @properties.count) do
            @loader.load
          end

          community = ApartmentCommunity.find_by_external_cms_id(external_cms_id(@property))
          attrs = community_attributes(@property)

          community_fields.each do |field|
            assert_equal attrs[field], community.send(field)
          end
        end

        context 'a community already exists with a vaultware id' do
          setup do
            @external_cms_id = external_cms_id(@property)
            @community       = ApartmentCommunity.make(:vaultware, :external_cms_id => @external_cms_id)
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

      context '#rolled_up?' do
        context 'when any Floorplan node contains more than 1 File node' do
          setup do
            load_vaultware_fixture_file('rolled_up.xml')
          end

          should 'return true' do
            assert @loader.send(:rolled_up?, @property)
          end
        end

        context 'when any Floorplan node contains 0 or 1 file nodes' do
          setup do
            load_vaultware_fixture_file('unrolled.xml')
          end

          should 'return false' do
            assert !@loader.send(:rolled_up?, @property)
          end
        end
      end

      context '#floor_plan_group' do
        should 'return penthouse when comment is penthouse' do
          @plan = mock_floor_plan(2, 'Penthouse')

          assert_equal ApartmentFloorPlanGroup.penthouse,
            @loader.send(:floor_plan_group, @plan)
        end

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
        context 'for a rolled up property' do
          setup do
            load_vaultware_fixture_file('rolled_up.xml')
            @loader.file = File.join(Rails.root, 'test', 'files', 'rolled_up.xml')

            @plans = @property.xpath('./Floorplan')

            @community = ApartmentCommunity.make(:vaultware,
              :external_cms_id => external_cms_id(@property)
            )

            @plans_attrs = attributes_for_rolled_up_floor_plans(@plans)
          end

          context 'when no matching floor plans exist' do
            should 'create the floor plans' do
              assert_difference('@community.floor_plans.count', @plans.count) do
                @loader.load
              end

              assert_equal @plans.count, @community.floor_plans.count

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  assert_equal attrs[field],
                    @community.floor_plans[i].send(field)
                end
              end
            end
          end

          context 'when syncing with a floor plan that already exists' do
            setup do
              @plan = @plans.first
              files = @plan.at('./File[Rank=1]')

              @community.floor_plans << ApartmentFloorPlan.make_unsaved(:vaultware,
                :external_cms_id      => @plan['Id'].to_i,
                :external_cms_file_id => (file['Id'].to_i rescue nil),
                :apartment_community  => @community,
                :image_url            => nil
              )
              @plans_attrs = attributes_for_rolled_up_floor_plans(@plans)
            end

            should 'update the floor plans' do
              assert_difference('@community.floor_plans.count', @plans.count - 1) do
                @loader.load
              end

              assert_equal @plans.count, @community.floor_plans.count

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  assert_equal attrs[field],
                    @community.floor_plans[i].send(field)
                end
              end
            end
          end
        end


        context 'for an unrolled property' do
          setup do
            load_vaultware_fixture_file('unrolled.xml')
            @loader.file = File.join(Rails.root, 'test', 'files', 'unrolled.xml')

            @community = ApartmentCommunity.make(:vaultware,
              :external_cms_id => external_cms_id(@property)
            )

            @plans = @property.xpath('./Floorplan')
            @plans_attrs = attributes_for_unrolled_floor_plans(@plans)
          end

          context "when no matching floor plans exist" do
            should 'create the floor plans' do
              assert_difference('@community.floor_plans.count', @plans.count) do
                @loader.load
              end

              assert_equal @plans.count, @community.floor_plans.count

              @plans_attrs.each_with_index do |attrs, i|
                attrs.each_key do |field|
                  assert_equal attrs[field],
                    @community.floor_plans[i].send(field)
                end
              end
            end
          end

          context 'when syncing with a floor plan that already exists' do
            setup do
              @penthouse = ApartmentFloorPlanGroup.penthouse

              @plan = @plans.first

              @community.floor_plans << ApartmentFloorPlan.make_unsaved(:vaultware,
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
      end

      context "processing hours" do
        setup do
          load_vaultware_fixture_file('unrolled.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'unrolled.xml')

          @hours = @property.xpath('./Information/OfficeHour')

          @community = ApartmentCommunity.make(:vaultware,
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
          load_vaultware_fixture_file('vaultware.xml')
          @loader.file = File.join(Rails.root, 'test', 'files', 'vaultware.xml')
        end

        should 'load all the properties and floor plans' do
          @loader.load

          @properties.each do |property|
            attrs = community_attributes(property)
            community = ApartmentCommunity.find_by_external_cms_id(attrs[:external_cms_id])

            community_fields.each do |field|
              assert_equal attrs[field], community.send(field)
            end

            plans = property.xpath('./Floorplan')
            attrs = if @loader.send(:rolled_up?, property)
              attributes_for_rolled_up_floor_plans(plans)
            else
              attributes_for_unrolled_floor_plans(plans)
            end

            attrs.each_with_index do |attrs, i|
              attrs.each_key do |field|
                assert_equal attrs[field],
                  community.floor_plans[i].send(field)
              end
            end
          end
        end
      end
    end


    def external_cms_id(property)
      property.at('./PropertyID/Identification/PrimaryID').content.to_i
    end

    def title(property)
      property.at('./PropertyID/Identification/MarketingName').content
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
      ident   = property.at('./PropertyID/Identification')
      address = property.at('./PropertyID/Address')
      info    = property.at('./Information')

      {
        :title             => ident.at('./MarketingName').content,
        :street_address    => address.at('./Address1').content,
        :availability_url  => info.at('./PropertyAvailabilityURL').content,
        :external_cms_id   => external_cms_id(property),
        :external_cms_type => 'vaultware'
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
      attrs[:external_cms_file_id] = file['Id'].to_i rescue nil
      attrs[:image_url] = file.at('./Src').content rescue nil
      attrs
    end

    def rolled_up_floor_plan_attributes(plan)
      attrs = floor_plan_attributes(plan)
      file = plan.at('./File[Rank=1]')
      attrs[:external_cms_file_id] = file['Id'].to_i rescue nil
      attrs[:image_url] = file.at('./Src').content rescue nil
      attrs[:rolled_up] = true
      attrs
    end

    def floor_plan_attributes(plan)
      {
        :name               => plan.at('./Name').content,
        :rolled_up          => false,
        :availability_url   => plan.at('./FloorplanAvailabilityURL').content,
        :available_units    => plan.at('./DisplayedUnitsAvailable').content.to_i,
        :bedrooms           => plan.at('./Room[@Type="Bedroom"]/Count').content.to_i,
        :bathrooms          => plan.at('./Room[@Type="Bathroom"]/Count').content.to_f,
        :min_square_feet    => plan.at('./SquareFeet')['Min'].to_i,
        :max_square_feet    => plan.at('./SquareFeet')['Max'].to_i,
        :min_market_rent    => plan.at('./MarketRent')['Min'].to_f,
        :max_market_rent    => plan.at('./MarketRent')['Max'].to_f,
        :min_effective_rent => plan.at('./EffectiveRent')['Min'].to_f,
        :max_effective_rent => plan.at('./EffectiveRent')['Max'].to_f,
        :external_cms_id    => plan['Id'].to_i,
        :external_cms_type  => 'vaultware'
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
      Nokogiri::XML(%{<Floorplan Id="1234"><Room Type="Bedroom"><Count>#{bedrooms}</Count></Room><Comment>#{comment}</Comment></Floorplan>}).at('./Floorplan')
    end

    def load_vaultware_fixture_file(file)
      @fixture = load_fixture_file(file)
      data     = Nokogiri::XML(@fixture)

      data.remove_namespaces!

      @properties = data.xpath('/PhysicalProperty/Property')
      @property   = @properties.first
    end
  end
end
