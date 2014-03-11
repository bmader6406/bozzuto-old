module PropertyPages
  class ToursController < BaseController
    self.property_page_type = :tours

    layout :detect_mobile_layout
  end
end
