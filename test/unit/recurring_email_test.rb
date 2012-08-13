require 'test_helper'

class RecurringEmailTest < ActiveSupport::TestCase
  context 'A recurring email' do
    context 'validations' do
      should_validate_presence_of :email_address
    end

    context 'on creation' do
      setup do
        @email = RecurringEmail.make
      end

      should 'auto generate a token' do
        assert @email.token.present?
      end
    end

    context '#properties' do
      setup do
        @published   = ApartmentCommunity.make
        @unpublished = ApartmentCommunity.make :unpublished

        @email = RecurringEmail.make :property_ids => [@published.id, @unpublished.id]
      end

      should 'only return published properties' do
        assert_equal [@published], @email.properties
      end
    end
  end
end
