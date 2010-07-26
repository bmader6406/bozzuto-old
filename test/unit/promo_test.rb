require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  context 'Promo' do
    should_have_many :apartment_communities,
      :home_communities,
      :landing_pages

    should_validate_presence_of :title, :subtitle

    context '#typus_name' do
      setup do
        @promo = Promo.new :title => 'Hey ya'
      end

      should 'return the title' do
        assert_equal 'Hey ya', @promo.typus_name
      end
    end
  end
end
