module PropertyPages
  class FeaturesController < BaseController
    has_mobile_actions :show

    self.property_page_type = "features"

    layout :detect_mobile_layout
  end
end
