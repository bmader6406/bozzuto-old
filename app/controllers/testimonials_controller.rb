class TestimonialsController < ApplicationController
  layout 'page'

  before_filter :find_section
  before_filter :find_testimonials, :only => :index

  def index
  end


  private

  def find_testimonials
    @testimonials = @section.section_testimonials
  end
end
