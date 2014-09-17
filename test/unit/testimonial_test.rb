require 'test_helper'

class TestimonialTest < ActiveSupport::TestCase
  context 'Testimonial' do
    should belong_to(:section)
    should validate_presence_of(:quote)
  end
end
