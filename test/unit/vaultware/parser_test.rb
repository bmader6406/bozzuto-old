require 'test_helper'

module Vaultware

class ParserTest < ActiveSupport::TestCase
  context 'A VaultwareParser' do
    setup do
      create_states

      @fixture = load_fixture_file('vaultware.xml')
      @data    = Nokogiri::XML(@fixture)

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
        assert_difference('Community.count', @data.xpath('/PhysicalProperty/Property').count) do
          @parser.parse(@file)
        end
      end
    end
  end
end

end
