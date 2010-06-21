require 'test_helper'

class TestimonialsControllerTest < ActionController::TestCase
  context 'TestimonialsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      setup do
        5.times do
          Testimonial.make :section => @section
        end
        @testimonials = @section.testimonials

        get :index, :section => @section.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:testimonials) { @testimonials }
    end
  end
end
