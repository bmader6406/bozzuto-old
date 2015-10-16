module Bozzuto
  class AdSourceCsv < Csv
    self.klass = AdSource

    self.field_map = {
      'Referrer'  => :domain_name,
      'Ad Source' => :value
    }
  end
end
