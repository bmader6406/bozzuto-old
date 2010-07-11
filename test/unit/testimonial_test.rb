require 'test_helper'

class TestimonialTest < ActiveSupport::TestCase
  context 'Testimonial' do
    should_belong_to :section
    should_validate_presence_of :quote
  end
end
