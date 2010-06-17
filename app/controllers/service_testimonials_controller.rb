class ServiceTestimonialsController < ApplicationController
  before_filter :find_service, :find_section

  def index
    @testimonials = @section.testimonials
  end


  private

  def find_service
    @service = Service.find_by_slug(params[:service_id])
  end

  def find_section
    @section = @service.section
  end
end
