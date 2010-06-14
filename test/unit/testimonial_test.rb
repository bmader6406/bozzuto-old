require 'test_helper'

class TestimonialTest < ActiveSupport::TestCase
  context 'Testimonial' do
    should_validate_presence_of :name, :title, :quote
  end
end
