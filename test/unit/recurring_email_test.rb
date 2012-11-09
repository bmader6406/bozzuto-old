require 'test_helper'

class RecurringEmailTest < ActiveSupport::TestCase
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

  context 'Class methods' do
    context '#needs_sending' do
      setup do
        @needs_sending = RecurringEmail.make(:recurring, :last_sent_at => 35.days.ago)
        @too_recent    = RecurringEmail.make(:recurring, :last_sent_at => 15.days.ago)
        @not_active    = RecurringEmail.make(:recurring, :state => 'unsubscribed')
        @not_recurring = RecurringEmail.make
      end

      should 'return the correct records' do
        assert_equal [@needs_sending], RecurringEmail.needs_sending
      end
    end
  end
end