module Bozzuto
  class DnrCsv < Csv
    self.klass = ApartmentCommunity

    self.field_map = {
      'Title'              => :title,
      'Website'            => proc { |c| (c.website_url.presence || '').split('?').first },
      'Phone Number'       => :phone_number,
      'DNR Account Number' => proc { |_| APP_CONFIG[:callsource]['apartment'] },
      'DNR Customer Code'  => proc { |c| c.dnr_configuration.try(:customer_code) }
    }

    def default_filename
      "#{Rails.root}/tmp/export-dnr-#{timestamp}.csv"
    end
  end
end
