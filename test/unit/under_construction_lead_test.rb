require 'test_helper'

class UnderConstructionLeadTest < ActiveSupport::TestCase
  context 'An Under Construction Lead' do
    setup { @lead = UnderConstructionLead.new }

    subject { @lead }

    should_belong_to :apartment_community

    should_validate_presence_of :email

    context '#apartment_community_title' do
      context 'when community is present' do
        setup { @lead.apartment_community = ApartmentCommunity.make }

        should 'return the title' do
          assert_equal @lead.apartment_community.title, @lead.apartment_community_title
        end
      end

      context 'when community is not present' do
        should 'return nil' do
          assert_nil @lead.apartment_community_title
        end
      end
    end
  end
end
