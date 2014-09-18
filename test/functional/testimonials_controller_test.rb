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
      end

      desktop_device do
        setup do
          get :index, :section => @section.to_param
        end

        should respond_with(:success)
        should render_with_layout(:page)
        should render_template(:index)
        should assign_to(:testimonials) { @testimonials }
      end

      mobile_device do
        setup do
          get :index, :section => @section.to_param
        end

        should respond_with(:success)
        should render_with_layout(:application)
        should render_template(:index)
        should assign_to(:testimonials) { @testimonials }
      end
    end
  end
end
