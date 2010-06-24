class TestimonialsController < SectionContentController
  before_filter :find_testimonials, :only => :index

  def index
  end


  private

  def find_testimonials
    @testimonials = section_testimonials.all
  end
end
