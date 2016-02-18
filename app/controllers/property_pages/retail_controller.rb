module PropertyPages
  class RetailController < BaseController
    has_mobile_actions :show

    self.property_page_type = 'retail'

    layout :detect_mobile_layout
  end
end
