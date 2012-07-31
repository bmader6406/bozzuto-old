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
  end
end
