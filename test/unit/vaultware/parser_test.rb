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
 
      context '#aggregate_floor_plans?' do
        context 'when any Floorplan node contains more than 1 File node' do
          setup do
            @plans = @property.xpath('./Floorplan')
          end

          should 'return true' do
            assert @parser.send(:aggregate_floor_plans?, @plans)
          end
        end

        context 'when any Floorplan node contains 0 or 1 flie nodes' do
          setup do
            @property = @properties[1]
            @plans = @property.xpath('./Floorplan')
          end

          should 'return false' do
            assert !@parser.send(:aggregate_floor_plans?, @plans)
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

        should 'destroy all existing floor plans' do
          @plan = @community.floor_plans.make
          @parser.process

          assert_nil @community.floor_plans.find_by_name(@plan.name)
        end
 
        context 'for an aggregate property' do
          setup do
            @plans = @property.xpath('./Floorplan')
          end

          should 'create the floor plans' do
            @parser.process

            assert_equal aggregate_floor_plan_count(@plans),
              @community.floor_plans.count
          end
        end

        context 'for a single property' do
          setup do
            @property = @properties[1]
            @community = ApartmentCommunity.make :vaultware_id => vaultware_id(@property)
            @plans = @property.xpath('./Floorplan')
          end

          should 'create the floor plans' do
            @parser.process

            assert_equal @plans.count, @community.floor_plans.count

            @community.floor_plans.each_with_index do |plan, i|
              attrs = floor_plan_attributes(@plans[i])
   
              floor_plan_fields.each do |field|
                assert_equal attrs[field], plan.send(field)
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
      :image_url
    ]
  end
 
  def floor_plan_attributes(plan)
    {
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
      :image_url          => plan.at('./File/Src').try(:content)
    }
  end

  def mock_floor_plan(bedrooms, comment = '')
    Nokogiri::XML(%{<Floorplan><Room Type="Bedroom"><Count>#{bedrooms}</Count></Room><Comment>#{comment}</Comment></Floorplan>}).at('./Floorplan')
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
end

end
