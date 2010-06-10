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
        assert_difference('Community.count', @properties.count) do
          @parser.process
        end
      end

      context 'a community already exists with a vaultware id' do
        setup do
          @vaultware_id = vaultware_id(@property)
          @community = Community.make :vaultware_id => @vaultware_id
        end

        should 'update the existing community' do
          assert_difference('Community.count', @properties.count - 1) do
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

          @community = Community.make :vaultware_id => vaultware_id(@property)
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
          @community = Community.find_by_vaultware_id(vaultware_id(@property))
        end

        should 'create the floor plans' do
          assert_equal @plans.count, @community.floor_plans.count
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
end

end
