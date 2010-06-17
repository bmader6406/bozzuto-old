require 'test_helper'

class ServiceTestimonialsControllerTest < ActionController::TestCase
  context 'ServiceTestimonialsController' do
    setup do
      @service = Service.make

      @testimonials = []
      3.times do
        @testimonials << Testimonial.make(:section => @service.section)
      end
    end

    context 'a GET to #index' do
      setup do
        get :index, :service_id => @service.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:testimonials) { @testimonials }
    end
  end
end
