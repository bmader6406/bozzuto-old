every 2.hours do
  rake 'bozzuto:sync_photo_sets'
end

every 1.day, :at => '4:00 am' do
  rake "-s sitemap:refresh"
end

every 1.day, :at => '6:00 am' do
  rake 'bozzuto:send_recurring_emails'
end

every 1.day, :at => '7:00 am' do
  rake 'bozzuto:refresh_local_info_feeds'
end

every 1.day, :at => ['10:15 am', '2:15 pm'] do
  rake 'bozzuto:load_vaultware_feed'
  rake 'bozzuto:load_property_link_feed'
  rake 'bozzuto:load_rent_cafe_feed'
  rake 'bozzuto:load_psi_feed'
end

every 1.day, :at => ['5:00 am', '5:00 pm'] do
  rake 'bozzuto:export_apartment_feed'
end

every 1.day, :at => ['3:00 am'] do
  rake 'buzzuto:export_contact_list_csvs'
end

if environment == 'production'
  every 1.day, :at => '9:00 am' do
    command 'cp /home/vault/bozzutocom.xml /home/bozzuto/'
  end
end
