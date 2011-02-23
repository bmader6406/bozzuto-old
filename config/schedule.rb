every 30.minutes do
  rake 'bozzuto:sync_twitter_accounts'
end

every 2.hours do
  rake 'bozzuto:sync_photo_sets'
end

every 1.day, :at => '8:00 am' do
  rake 'bozzuto:load_vaultware_feed'
end

every 1.day, :at => '7:00 am' do
  rake 'bozzuto:refresh_local_info_feeds'
end
