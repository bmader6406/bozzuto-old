class TestimonialsController < SectionContentController
  has_mobile_actions :index

  def index
    @testimonials = section_testimonials.all
  end
end
