require 'test_helper'

module Vaultware

class ParserTest < ActiveSupport::TestCase
  context 'A VaultwareParser' do
    setup do
      create_states

      @fixture    = load_fixture_file('vaultware.xml')
      @data       = Nokogiri::XML(@fixture)
      @properties = @data.xpath('/PhysicalProperty/Property')

      @parser = Vaultware::Parser.new
    end

    context '#parse' do
      setup do
        @file = RAILS_ROOT + '/test/fixtures/vaultware.xml'
      end

      should 'load the file' do
        @parser.parse(@file)
        assert @parser.data
        assert @parser.data.xpath('/PhysicalProperty').present?
      end

      should 'create the communities' do
        assert_difference('Community.count', @properties.count) do
          @parser.parse(@file)
        end
      end

      context 'a community already exists with a vaultware id' do
        setup do
          @property = @properties.first
          @vaultware_id = @property.at('./PropertyID/ns:Identification/ns:PrimaryID', ns).content.to_i
          @community = Community.make :vaultware_id => @vaultware_id
        end

        should 'update the existing community' do
          assert_difference('Community.count', @properties.count - 1) do
            @parser.parse(@file)
          end

          @community.reload

          assert_equal @property.at('./PropertyID/ns:Identification/ns:MarketingName', ns).content,
            @community.title
        end
      end
    end
  end

  def ns
    { 'ns' => 'http://my-company.com/namespace' }
  end
end

end
