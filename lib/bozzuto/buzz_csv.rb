module Bozzuto
  class BuzzCsv < Csv
    self.klass = Buzz

    self.field_map = ActiveSupport::OrderedHash[[
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
  end
end
