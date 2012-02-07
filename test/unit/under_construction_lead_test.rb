require 'test_helper'

class UnderConstructionLeadTest < ActiveSupport::TestCase
  context 'An Under Construction Lead' do
    setup { @lead = UnderConstructionLead.new }

    subject { @lead }

    should_belong_to :apartment_community

    should_validate_presence_of :first_name, :last_name, :phone_number, :email
  end
end
