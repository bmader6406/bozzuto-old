class FeaturesController < PropertyPagesController
  self.property_page_type = "features"

  layout :detect_mobile_layout


  private

  def detect_mobile_layout
    mobile? ? 'application' : 'community'
  end
end
