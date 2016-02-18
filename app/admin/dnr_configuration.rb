ActiveAdmin.register DnrConfiguration do
  menu parent: 'Ronin'

  #TODO This is basically a single `customer_code` field on Property.
  # Should probably be a nested form on HomeCommunity & ApartmentCommunity
end
