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

    context '#parse' do
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

      context 'processing floor plan groups' do
        setup do
          @groups = @property.xpath('Floorplan').map { |plan|
            plan.at('./Comment').try(:content)
          }.compact.uniq.sort

          @community = ApartmentCommunity.make :vaultware_id => vaultware_id(@property)
        end

        should 'create the floor plan groups' do
          @parser.process
          @community.reload

          assert_equal @groups.count, @community.floor_plan_groups.count

          @community.floor_plan_groups.each_with_index do |group, i|
            assert_equal @groups[i], group.name
          end
        end

        should 'destroy any existing floor plan groups' do
          group = FloorPlanGroup.make
          @community.floor_plan_groups << group
          @parser.process

          assert_nil @community.floor_plan_groups.find_by_name(group.name)
        end
      end

      context 'processing floor plans' do
        setup do
          @plans = @property.xpath('Floorplan')
          @parser.process
          @community = ApartmentCommunity.find_by_vaultware_id(vaultware_id(@property))
        end

        should 'create the floor plans' do
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
      :image
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
      :image              => plan.at('./File/Src').try(:content)
    }
  end
end

end
