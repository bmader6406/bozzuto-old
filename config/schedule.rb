every 2.hours do
  rake 'bozzuto:sync_photo_sets'
end

every 1.day, :at => '8:00 am' do
  rake 'bozzuto:load_vaultware_feed'
end
