require 'test_helper'

module Vaultware
  class ParserTest < ActiveSupport::TestCase
    context 'A VaultwareParser' do
      setup do
        create_states
   
        @fixture    = load_fixture_file('vaultware.xml')
        @data       = Nokogiri::XML(@fixture)
        @properties = @data.xpath('/PhysicalProperty/Property')
        @property   = @properties.first
   
        @parser = Vaultware::Parser.new
      end
   
      context '#process' do
        setup do
          @file = RAILS_ROOT + '/test/fixtures/vaultware.xml'
          @parser.parse(@file)
        end

        should 'load the file' do
          @parser.process
          assert @parser.data
          assert @parser.data.xpath('/PhysicalProperty').present?
        end
   
        should 'create the communities' do
          assert_difference('ApartmentCommunity.count', @properties.count) do
            @parser.process
          end
   
          community = ApartmentCommunity.find_by_vaultware_id(vaultware_id(@property))
          attrs = community_attributes(@property)
   
          community_fields.each do |field|
            assert_equal attrs[field], community.send(field)
          end
        end
   
        context 'a community already exists with a vaultware id' do
          setup do
            @vaultware_id = vaultware_id(@property)
            @community = ApartmentCommunity.make :vaultware_id => @vaultware_id
          end
   
          should 'update the existing community' do
            assert_difference('ApartmentCommunity.count', @properties.count - 1) do
              @parser.process
            end
   
            @community.reload

            assert_equal title(@property), @community.title
          end
        end
   
        context '#aggregate_floor_plan?' do
          context 'when any Floorplan node contains more than 1 File node' do
            setup do
              @plans = @property.xpath('./Floorplan')
            end

            should 'return true' do
              assert @parser.send(:aggregate_floor_plan?, @plans.first)
            end
          end

          context 'when any Floorplan node contains 0 or 1 file nodes' do
            setup do
              @property = @properties[1]
              @plans = @property.xpath('./Floorplan')
            end

            should 'return false' do
              assert !@parser.send(:aggregate_floor_plan?, @plans.first)
            end
          end
        end

        context '#floor_plan_group' do
          should 'return penthouse when comment is penthouse' do
            @plan = mock_floor_plan(2, 'Penthouse')

            assert_equal ApartmentFloorPlanGroup.penthouse,
              @parser.send(:floor_plan_group, @plan)
          end

          should 'return studio when bedrooms is 0' do
            @plan = mock_floor_plan(0, '')

            assert_equal ApartmentFloorPlanGroup.studio,
              @parser.send(:floor_plan_group, @plan)
          end

          should 'return one bedroom when bedrooms is 1' do
            @plan = mock_floor_plan(1, '')

            assert_equal ApartmentFloorPlanGroup.one_bedroom,
              @parser.send(:floor_plan_group, @plan)
          end

          should 'return two bedrooms when bedrooms is 2' do
            @plan = mock_floor_plan(2, '')

            assert_equal ApartmentFloorPlanGroup.two_bedrooms,
              @parser.send(:floor_plan_group, @plan)
          end

          should 'return three bedrooms when bedrooms is 3 or more' do
            @plan = mock_floor_plan(3, '')

            assert_equal ApartmentFloorPlanGroup.three_bedrooms,
              @parser.send(:floor_plan_group, @plan)

            @plan = mock_floor_plan(5, '')

            assert_equal ApartmentFloorPlanGroup.three_bedrooms,
              @parser.send(:floor_plan_group, @plan)
          end
        end


        context 'processing floor plans' do
          setup do
            @community = ApartmentCommunity.make :vaultware_id => vaultware_id(@property)
          end

          context 'for an aggregate property' do
            setup do
              @plans = @property.xpath('./Floorplan')
              @total_plans = aggregate_floor_plan_count(@plans)
              @plans_attrs = attributes_for_floor_plans(@plans)
            end

            context 'when no matching floor plans exist' do
              should 'create the floor plans' do
                assert_difference('@community.floor_plans.count', @total_plans) do
                  @parser.process
                end

                assert_equal @total_plans, @community.floor_plans.count

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
                @files = @plan.xpath('./File')

                @files.each do |file|
                  @community.floor_plans << ApartmentFloorPlan.make_unsaved(
                    :vaultware_floor_plan_id => @plan['Id'].to_i,
                    :vaultware_file_id       => file['Id'].to_i,
                    :apartment_community     => @community,
                    :image_url               => nil
                  )
                end
              end

              should 'update the floor plans' do
                assert_difference('@community.floor_plans.count', @total_plans - @files.count) do
                  @parser.process
                end

                assert_equal @total_plans, @community.floor_plans.count
              end
            end
          end


          context 'for a single property' do
            setup do
              @property = @properties[1]
              @community = ApartmentCommunity.make :vaultware_id => vaultware_id(@property)
              @plans = @property.xpath('./Floorplan')
              @plans_attrs = attributes_for_floor_plans(@plans)
            end

            context "when no matching floor plans exist" do
              should 'create the floor plans' do
                assert_difference('@community.floor_plans.count', @plans.count) do
                @parser.process
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
                @community.floor_plans << ApartmentFloorPlan.make_unsaved(
                  :vaultware_floor_plan_id => @plan['Id'].to_i,
                  :apartment_community     => @community,
                  :image_url               => nil
                )
              end

              should 'update the existing floor plan' do
                assert_difference('@community.floor_plans.count', @plans.count - 1) do
                  @parser.process
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
        end
      end
    end
   
   
    def ns
      { 'ns' => 'http://my-company.com/namespace' }
    end
   
    def vaultware_id(property)
      property.at('./PropertyID/ns:Identification/ns:PrimaryID', ns).content.to_i
    end
   
    def title(property)
      property.at('./PropertyID/ns:Identification/ns:MarketingName', ns).content
    end
   
    def community_fields
      [
        :title,
        :website_url,
        :street_address,
        :availability_url
      ]
    end
   
    def community_attributes(property)
      ident   = property.at('./PropertyID/ns:Identification', ns)
      address = property.at('./PropertyID/ns:Address', ns)
      info    = property.at('./Information')
   
      {
        :title            => ident.at('./ns:MarketingName', ns).content,
        :website_url      => ident.at('./ns:WebSite', ns).try(:content),
        :street_address   => address.at('./ns:Address1', ns).content,
        :availability_url => info.at('./PropertyAvailabilityURL').content
      }
    end
   
   
    def floor_plan_fields
      [
        :name,
        :availability_url,
        :bedrooms,
        :bathrooms,
        :min_square_feet,
        :max_square_feet,
        :min_market_rent,
        :max_market_rent,
        :min_effective_rent,
        :max_effective_rent,
        :vaultware_floor_plan_id,
        :vaultware_file_id,
        :image_url
      ]
    end

    def attributes_for_floor_plans(plans)
      plans.inject([]) do |array, plan|
        files = plan.xpath('./File')

        if files.count == 0 || files.count == 1
          array << floor_plan_attributes(plan)
        else
          files.each do |file|
            array << floor_plan_attributes(plan, file)
          end
        end

        array
      end
    end

    def floor_plan_attributes(plan, file = nil)
      file ||= plan.at('./File')

      attrs = {
        :name               => plan.at('./Name').content,
        :availability_url   => plan.at('./FloorplanAvailabilityURL').content,
        :bedrooms           => plan.at('./Room[@Type="Bedroom"]/Count').content.to_i,
        :bathrooms          => plan.at('./Room[@Type="Bathroom"]/Count').content.to_f,
        :min_square_feet    => plan.at('./SquareFeet')['Min'].to_i,
        :max_square_feet    => plan.at('./SquareFeet')['Max'].to_i,
        :min_market_rent    => plan.at('./MarketRent')['Min'].to_f,
        :max_market_rent    => plan.at('./MarketRent')['Max'].to_f,
        :min_effective_rent => plan.at('./EffectiveRent')['Min'].to_f,
        :max_effective_rent => plan.at('./EffectiveRent')['Max'].to_f,
        :vaultware_floor_plan_id => plan['Id'].to_i
      }

      if file.present?
        attrs.merge!(
          :vaultware_file_id => file['Id'].to_i,
          :image_url         => file.at('./Src').content
        )
      end

      attrs
    end

    def aggregate_floor_plan_count(plans)
      plans.inject(0) do |total, plan|
        if plan.xpath('./File').count == 0
          total += 1
        else
          total += plan.xpath('./File').count
        end
      end
    end

    def mock_floor_plan(bedrooms, comment = '')
      Nokogiri::XML(%{<Floorplan Id="1234"><Room Type="Bedroom"><Count>#{bedrooms}</Count></Room><Comment>#{comment}</Comment></Floorplan>}).at('./Floorplan')
    end
  end

end
