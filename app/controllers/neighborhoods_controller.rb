class NeighborhoodsController < PropertyPagesController
  self.property_page_type = "neighborhood"

  layout :detect_mobile_layout


  private

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
