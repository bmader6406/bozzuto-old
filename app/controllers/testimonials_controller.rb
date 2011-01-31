class TestimonialsController < SectionContentController
  def index
    @testimonials = section_testimonials.all
  end
end
