every 1.hour do
  rake 'bozzuto:sync_twitter_accounts'
end

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

every 1.day, :at => '7:30 am' do
  rake 'bozzuto:load_property_link_feed'
end

every 1.day, :at => '8:30 am' do
  rake 'bozzuto:load_vaultware_feed'
end

every 1.day, :at => ['5:00 am', '5:00 pm'] do
  rake 'bozzuto:export_apartment_feed'
end
