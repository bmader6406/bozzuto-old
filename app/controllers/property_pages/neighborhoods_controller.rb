module PropertyPages
  class NeighborhoodsController < BaseController
    has_mobile_actions :show

    self.property_page_type = "neighborhood"

    layout :detect_mobile_layout
  end
end
