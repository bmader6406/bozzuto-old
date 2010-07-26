require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  context 'Promo' do
    should_validate_presence_of :title
  end
end
