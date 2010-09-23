require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  context 'Promo' do
    setup { @promo = Promo.new }
    subject { @promo }

    should_have_many :apartment_communities,
      :home_communities,
      :landing_pages

    should_validate_presence_of :title, :subtitle

    context '#typus_name' do
      setup { @promo.title = 'Hey ya' }

      should 'return the title' do
        assert_equal 'Hey ya', @promo.typus_name
      end
    end

    context 'has_expiration_date is false' do
      setup do
        @promo.has_expiration_date = false
      end

      should 'set expiration_date to nil before validation' do
        @promo.expiration_date = Time.now
        assert @promo.expiration_date.present?
        @promo.valid?
        assert_nil @promo.expiration_date
      end

      should 'allow nil for expiration_date' do
        @promo.expiration_date = nil
        @promo.valid?
        assert_nil @promo.errors.on(:expiration_date)
      end
    end

    context 'has_expiration_date is true' do
      setup do
        @promo.has_expiration_date = true
        @promo.expiration_date = nil
      end

      should_validate_presence_of :expiration_date
    end
  end
end
