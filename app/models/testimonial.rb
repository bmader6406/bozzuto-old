class Testimonial < ActiveRecord::Base

  belongs_to :section

  validates :quote,
            presence: true

  def excerpt(limit = 100)
    return if quote.nil?

    ActionView::Base.full_sanitizer.sanitize(quote).first(limit)
  end
end
