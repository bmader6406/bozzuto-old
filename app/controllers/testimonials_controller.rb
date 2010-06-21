class TestimonialsController < ApplicationController
  before_filter :find_section
  before_filter :find_testimonials, :only => :index

  def index
  end


  private

  def find_testimonials
    @testimonials = @section.testimonials
  end
end
