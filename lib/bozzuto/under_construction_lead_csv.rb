module Bozzuto
  class UnderConstructionLeadCsv < Csv
    self.klass = UnderConstructionLead

    self.field_map = ActiveSupport::OrderedHash[[
      ['PropertyName',:apartment_community_title],
      ['TheID', nil],
      ['PropertyId', nil],
      ['Address', :address],
      ['City', :city],
      ['State', :state],
      ['Zip', :zip_code],
      ['HomePhone', :phone_number],
      ['CellPhone', nil],
      ['Email', :email],
      ['MoveInDate', nil],
      ['DesiredLease', nil],
      ['Description', :comments],
      ['FirstName', :first_name],
      ['LastName', :last_name],
      ['Address2', :address_2],
      ['WorkPhone', nil],
      ['DogCount',  nil],
      ['CatCount',  nil],
      ['PetNotes',  nil],
      ['MinPrice',  nil],
      ['MaxPrice',  nil],
      ['BedCount',  nil],
      ['BathCount', nil],
      ['FloorplanId', nil],
      ['LeadCategoryId', nil],
      ['LeadPriorityId', nil],
      ['UserId', nil],
      ['LeadType', nil],
      ['LeadSource', nil],
      ['FollowupDate', nil],
      ['FollowUpDescription', nil],
      ['LeadSourceConduit', nil],
      ['Datelog', :created_at]
    ]]
  end
end
