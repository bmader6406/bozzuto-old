module Bozzuto
  class BuzzCsv < Csv
    KLASS = Buzz

    FIELD_MAP = ActiveSupport::OrderedHash[[
      ['Email', :email],
      ['First Name', :first_name],
      ['Last Name', :last_name],
      ['Street 1', :street1],
      ['Street 2', :street2],
      ['City', :city],
      ['State', :state],
      ['Zip Code', :zip_code],
      ['Phone', :phone],
      ['Buzzes', :formatted_buzzes],
      ['Affiliations', :formatted_affiliations],
      ['Created At', :created_at]
    ]]

    def klass
      KLASS
    end

    def field_map
      FIELD_MAP
    end
  end
end
